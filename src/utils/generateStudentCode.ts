import prisma from "../config/prisma"

export const generateStudentCode = async (
    name: string
): Promise<string> => {
    const initials = name
        .trim()
        .split(/\s+/)
        .map(word => word[0].toUpperCase())
        .join("")
        .padEnd(3, "X")
        .slice(0, 3);

    while (true) {
        const randomNumber = Math.floor(
            1000 + Math.random() * 9000
        );

        const studentCode = `${initials}-${randomNumber}`;

        const existingStudent = await prisma.student.findUnique({
            where: {
                student_code: studentCode
            }
        });

        if (!existingStudent) {
            return studentCode
        }
    }
}