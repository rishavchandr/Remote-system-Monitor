import {Router} from 'express'
import authMiddlewares from '../middlewares/auth.middleware.js'
import { registerDevice,listDevices} from '../controllers/device.controller.js'

const router = Router();

router.route('/registerDevice').post(authMiddlewares,registerDevice)
router.route('/devices').get(authMiddlewares,listDevices)

export default router