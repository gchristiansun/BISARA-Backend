import { z } from "zod";

// Skema validasi add student
export const addStudentShema = z.object({
    name: z.string().min(3, 'Name is required (min 3 chars'),
    disability_type: z.enum(
        ["tunarungu", "tunawicara"], 
        {
            error: "Disability type must be either tunarungu or tunawicara"
        }
    ),
})

// Skema validasi login student
export const loginStudentSchema = z.object({
    student_code: z.string()
})

// Skema update student
export const updateStudentSchema = addStudentShema.partial()

export type AddStudentInput = z.infer<typeof addStudentShema>
export type LoginStudentInput = z.infer<typeof loginStudentSchema>
export type UpdateStudentInput = z.infer<typeof updateStudentSchema>