import prisma from "../../config/prisma";
import { hashPassword } from "../../utils/password";
import { RegisterTeacherInput } from "./teacher.validation";

// Cek Email
export const findTeacheByEmail = async (email:string) => {
    return await prisma.teacher.findUnique({
        where: {email: email}
    })
}

// Buat Teacher Baru
export const createTeacher = async (input: RegisterTeacherInput) => {
    const hashedPassword = await hashPassword(input.password)

    const teacher = await prisma.teacher.create({
        data: {
            name: input.name,
            email: input.email,
            password: hashedPassword
        }
    })

    return teacher;
}

// Simpan Refresh Token
export const saveRefreshTokenTeacher = async (teacherId: string, refreshToken: string) => {
    return await prisma.teacher.update({
        where: { id: teacherId },
        data: {
            refresh_token: refreshToken
        }
    })
}

// Hapus Refresh Token
export const clearRefreshToken = async (refreshToken: string) => {
    return await prisma.teacher.update({
        where: { refresh_token: refreshToken },
        data: {
            refresh_token: null
        }
    })
}

// Cari Teacher Berdasarkan Refresh Token
export const findTeacherByToken = async (refreshToken: string) => {
    return await prisma.teacher.findUnique({
        where: {
            refresh_token: refreshToken,
        }
    })
}