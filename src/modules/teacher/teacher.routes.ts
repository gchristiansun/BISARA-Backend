import { Router } from "express";
import * as teacherController from "./teacher.controller"
import { validateRequest } from "../../middleware/validateRequest";
import * as teacherValidation from "./teacher.validation"

const teacherRouter = Router();

// Route untuk Regiter
teacherRouter.post(
    "/register",
    validateRequest(teacherValidation.registerTeacherSchema),
    teacherController.registerTeacherHandler
)

// Route untuk Login
teacherRouter.post(
    "/login",
    validateRequest(teacherValidation.loginTeacherSchema),
    teacherController.loginTeacherHandler
)

// Route untuk Logout
teacherRouter.post(
    "/logout",
    teacherController.logoutTeacherHandler
)

// Route untuk Logout
teacherRouter.post(
    "/refresh-token",
    teacherController.refresfAccessTokenHandler
)

export default teacherRouter;