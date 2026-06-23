import { Request, Response, NextFunction } from "express";
import * as teacherService from "./teacher.service";
import { HttpError } from "../../utils/httpError";
import { 
    signAccessToken,
    signRefreshToken,
    verifyRefreshToken
} from "../../utils/jwt";
import {
    UpdateTeacherInput
} from "./teacher.validation"
import { UserPayload } from "../../middleware/auth.middleware"
import { comparePassword } from "../../utils/password";

type teacherParams = {
    id: string
}

// Handle Register Teacher
export const registerTeacherHandler = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const { name, email, password} = req.body;
        const existingTeacher = await teacherService.findTeacheByEmail(email);
        if (existingTeacher) {
            throw new HttpError(409, "Email already exists")
        }

        const teacher = await teacherService.createTeacher({
            name,
            email,
            password
        })

        return res.status(201).json({
            message: "Teacher registered succesfully",
            data: {
                id: teacher.id,
                name: teacher.name,
                email: teacher.email,
            }
        })
    } catch (error) {
        next(error)
    }
}

// Handle Login Teacher
export const loginTeacherHandler = async (
    req: Request, 
    res: Response, 
    next: NextFunction
) => {
    try {
        const { email, password} = req.body;
        const teacher = await teacherService.findTeacheByEmail(email)
        if (!teacher) {
            throw new HttpError(404, 'User not found')
        }
        if(!teacher.password) {
            throw new HttpError(401, 'Invalid password')
        }

        const isPasswordValid = await comparePassword(password, teacher.password)
        if(!isPasswordValid) {
            throw new HttpError(401, "Invalid email or password")

        }

        const payload = { id: teacher.id }

        // Buat Access Token Singkat dan Refresh Token yang Lebih Lama
        const accessToken = signAccessToken(payload);
        const refreshToken = signRefreshToken(payload)

        // Simpan Refresh Token ke Database
        await teacherService.saveRefreshTokenTeacher(teacher.id, refreshToken)

        // Simpan Refresh Token Sebagai httpOnly Cookie
        res.cookie('refreshToken', refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 7 * 24 * 60 * 1000
        });

        // Kirim Access Token Sebagai JSON
        return res.status(200).json({
            accessToken,
            teacher: {
                id: teacher.id,
                name: teacher.name,
                email: teacher.email
            }
        })
    } catch (error) {
        next(error);
    }
}

// Refresh Token
export const refresfAccessTokenHandler = async (
    req: Request, 
    res: Response,
    next: NextFunction
) => {
    try {
        const tokenFromCookie = req.cookies.refreshToken;
        if (!tokenFromCookie) {
            throw new HttpError(401, 'No refresh token provided')
        }

        const payload = verifyRefreshToken(tokenFromCookie) as UserPayload;
        if (!payload) {
            throw new HttpError(403, 'Invalid or expired refresh token');
        }

        const teacher = await teacherService.findTeacherByToken(tokenFromCookie);
        if (!teacher || teacher.id !== payload.id) {
            throw new HttpError(403, 'Invalid token or teacher mismatch')
        }

        // Buat Access Token Baru
        const newAccessToken = signAccessToken({
            id: teacher.id
        })

        return res.status(200).json({
            accessToken: newAccessToken
        })
    } catch (error) {
        next(error)
    }
}

// Logout
export const logoutTeacherHandler = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const tokenFromCookie = req.cookies.refreshToken;

        if (tokenFromCookie) {
            await teacherService.clearRefreshToken(tokenFromCookie)
        }

        res.cookie('refreshToken', '', {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            expires: new Date(0)
        })

        return res.status(200).json({
            message: "Logged out successfully"
        })
    } catch (error) {
        next(error)
    }
}

// Get Teacher By Id
export const getTeacherById = async (
    req: Request<teacherParams>,
    res: Response,
    next: NextFunction
) => {
    try {
        const { id } = req.params;
        const teacher = await teacherService.getTeacherById(id);

        if (!teacher) {
            throw new HttpError(404, 'teacher not found')
        }

        res.json(teacher)
    } catch (error) {
        next(error)
    }
}

// Update Teacher
export const updateTeacher = async (
    req: Request<teacherParams>,
    res: Response,
    next: NextFunction
) => {
    try {
        const { id } = req.params;
        const updated = await teacherService.updateTeacher(id, req.body);
        res.json(updated)
    } catch (error) {
        next(error)
    }
}

// Delete Teacher
export const deleteTeacher = async (
    req: Request<teacherParams>,
    res: Response,
    next: NextFunction
) => {
    try {
        const { id } = req.params;
        await teacherService.deleteTeacher(id);
        res.status(204).send()
    } catch (error) {
        next(error)
    }
}