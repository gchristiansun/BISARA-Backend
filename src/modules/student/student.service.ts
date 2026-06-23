import prisma from "../../config/prisma";
import { generateStudentCode } from "../../utils/generateStudentCode";
import { 
    AddStudentInput,
    UpdateStudentInput
} from "./student.validation";

// Temukan Student By Student Code
export const findStudentByStudentCode = async (student_code: string) => {
    return await prisma.student.findUnique({
        where: { student_code: student_code}
    })
}

// Add Student Baru
export const addStudent = async (input: AddStudentInput) => {
    const studentCode = await generateStudentCode(input.name)

    const student = await prisma.student.create({
        data: {
            name: input.name, 
            disability_type: input.disability_type,
            student_code: studentCode
        }
    })

    return student;
}

// Simpan Refresh Token
export const saveRefreshTokenStudent = async (studentId: string, refreshToken: string) => {
    return await prisma.student.update({
        where: { id: studentId },
        data: {
            refresh_token: refreshToken
        }        
    })
}

// Hapus Refresh Token
export const clearRefreshTokenStudent = async (refreshToken:string) => {
    return await prisma.student.update({
        where: { refresh_token: refreshToken},
        data: {
            refresh_token: null
        }
    })
}

// Cari Student Berdasarkan Refresh Token
export const findStudentByToken = async (refreshToken: string) => {
    return await prisma.student.findUnique({
        where: {
            refresh_token: refreshToken
        }
    })
}

// Get Student By Id
export const getStudentById = async (id: string) => {
    return await prisma.student.findUnique({
        where: {
            id
        }
    })
}

// Update Student
export const updateStudent = async (id: string, data: UpdateStudentInput) => {
    return prisma.student.update({
        where: { id },
        data
    })
}

// Delete Student
export const deleteStudent = async (id: string) => {
    return prisma.student.delete({
        where: { id }
    })
}