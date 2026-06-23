import { z } from "zod";
import { partial } from "zod/mini";

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

export type RegisterTeacherInput = z.infer<typeof registerTeacherSchema>
export type LoginTeacherInput = z.infer<typeof loginTeacherSchema>