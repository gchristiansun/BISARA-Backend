import { z } from "zod";

// Skema validasi register
export const registerTeacherSchema = z.object({
    name: z.string().min(3, 'Name is required (min 3 chars'),
    email: z.email('Invalid email address'),
    password: z.string().min(8 ,'Password must be at least 8 characters')    
})

// Skema validasi login
export const loginTeacherSchema = z.object({
    email: z.email('Invalid email address'),
    password: z.string().min(8, 'Password must be at least 8 characters')
})

// Skema validasi update
export const updateTeacherSchema = z.object({
    name: z.string().min(3, 'Name is required (min 3 chars').optional(),
    email: z.email('Invalid email address').optional(),
    password: z.string().min(8, 'Password must be at least 8 characters').optional(),
    nip: z.string().optional(),
    instansi: z.string().optional()
})

export type RegisterTeacherInput = z.infer<typeof registerTeacherSchema>
export type LoginTeacherInput = z.infer<typeof loginTeacherSchema>
export type UpdateTeacherInput = z.infer<typeof updateTeacherSchema>