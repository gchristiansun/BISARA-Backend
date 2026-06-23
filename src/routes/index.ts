import { Router } from "express";
import teacherRouter from "../modules/teacher/teacher.routes";
import studentRouter from "../modules/student/student.routes"

const mainApiRouter = Router();

mainApiRouter.use('/teacher', teacherRouter)
mainApiRouter.use('/student', studentRouter)

export default mainApiRouter;