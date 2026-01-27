import {Router} from 'express'
import {registerUser,userLogin,logOutUser} from '../controllers/auth.controller.js'
import authMiddlewares from '../middlewares/auth.middleware.js'

const router = Router()

router.route('/register').post(registerUser)
router.route('/login').post(userLogin)
router.route('/logout').post(logOutUser)

export default router