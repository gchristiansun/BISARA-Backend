import { Router } from "express";
import authRouter from "../modules/auth/auth.routes";
import teacherRouter from "../modules/teacher/teacher.routes";

const mainApiRouter = Router();

mainApiRouter.use('/teacher', teacherRouter)

export default mainApiRouter;