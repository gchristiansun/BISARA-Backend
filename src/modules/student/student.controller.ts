import { Request, Response, NextFunction } from "express";
import * as studentService from "./student.service";
import { HttpError } from "../../utils/httpError";
import {
    signAccessToken, 
    signRefreshToken,
    verifyRefreshToken
} from "../../utils/jwt";
import { UserPayload } from "../../middleware/auth.middleware";

type studentParams = {
    id: string
}

// Handle Add student
export const addStudentHandler = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const { name, disability_type } = req.body;

        const student = await studentService.addStudent({
            name, 
            disability_type,
        })

        return res.status(201).json({
            message: "Add student succesfully",
            data: {
                id: student.id,
                name: student.name,
                disability_type: student.disability_type,
                student_code: student.student_code
            }
        })
    } catch (error) {
        next(error)
    }
}

// Handle Login Student
export const loginStudentHandler = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const { student_code } = req.body;
        const student = await studentService.findStudentByStudentCode(student_code);
        if (!student) {
            throw new HttpError(404, 'Student not Found')
        }

        const payload = { id: student.id }

        // Buat Access Token Singkat dan Refresh Token yang Lebih Lama
        const accessToken = signAccessToken(payload)
        const refreshToken = signRefreshToken(payload)

        // Simpan Refresh Toke ke Database
        await studentService.saveRefreshTokenStudent(student.id, refreshToken)

        // Simpan Refreh Token Sebagai httpOnly Cookie
        res.cookie('refreshToken', refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 7 * 24 * 60 * 1000
        });

        // Kirim Access Token Sebagai JSON
        return res.status(200).json({
            accessToken,
            student: {
                id: student.id,
                name: student.name,
                disability_type: student.disability_type
            }
        })
    } catch (error) {
        next(error)
    }
}

// Refresh Token
export const refreshAccessTokenHandler = async (
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

        const student= await studentService.findStudentByToken(tokenFromCookie);
        if (!student || student.id!== payload.id) {
            throw new HttpError(403, 'Invalid token or student mismatch')
        }

        // Buat Access Token Baru
        const newAccessToken = signAccessToken({
            id: student.id
        })

        return res.status(200).json({
            accessToken: newAccessToken
        })
    } catch (error) {
        next(error)
    }
}

// Logout
export const logoutStudentHandler = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const tokenFromCookie = req.cookies.refreshToken;

        if (tokenFromCookie) {
            await studentService.clearRefreshTokenStudent(tokenFromCookie)
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

// Get Student By Id
export const getStudentById = async (
    req: Request<studentParams>,
    res: Response,
    next: NextFunction
) => {
    try {
        const { id } = req.params;
        const student = await studentService.getStudentById(id);

        if (!student) {
            throw new HttpError(404, 'Student not found')
        }

        res.json(student); 
    } catch (error) {
        next(error)
    }
}

// Update Student
export const updateStudent = async (
    req: Request<studentParams>,
    res: Response,
    next: NextFunction
) => {
    try {
        const { id } = req.params;
        const updated = await studentService.updateStudent(id, req.body);
        res.json(updated)
    } catch (error) {
        next(error)
    }
}

// Delete Student
export const deleteStudent = async (
    req: Request<studentParams>,
    res: Response,
    next: NextFunction
) => {
    try {
        const { id } = req.params
        await studentService.deleteStudent(id)
        res.status(204).send()
    } catch (error) {
        next(error)
    }
}