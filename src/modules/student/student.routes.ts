import { Router } from "express";
import * as studentController from "./student.controller";
import { validateRequest } from "../../middleware/validateRequest";
import * as studentValidation from "./student.validation"

const studentRouter = Router();

// Route untuk Add
studentRouter.post(
    "/add",
    validateRequest(studentValidation.addStudentShema),
    studentController.addStudentHandler
)

// Route untuk Login
studentRouter.post(
    "/login",
    validateRequest(studentValidation.loginStudentSchema),
    studentController.loginStudentHandler
)

// Route untuk Logout
studentRouter.post(
    "/logout",
    studentController.logoutStudentHandler
)

// Route untuk Refresh Token
studentRouter.post(
    "/refresh-token",
    studentController.refreshAccessTokenHandler
)

// Get Student By Id
studentRouter.get(
    "/:id",
    studentController.getStudentById
)

// Update Student
studentRouter.put(
    "/:id",
    validateRequest(studentValidation.updateStudentSchema),
    studentController.updateStudent
)

// Delete Student
studentRouter.delete(
    "/:id",
    studentController.deleteStudent
)

export default studentRouter;