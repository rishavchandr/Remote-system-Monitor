import {Router} from 'express'
import {ingestMetric
,getMetrics} from '../controllers/metric.controller.js'
import authMiddleWare from '../middlewares/auth.middleware.js'
import {deviceAuth} from '../middlewares/device.middleware.js'

const router = Router()

router.post('/',deviceAuth,ingestMetric)
router.get('/:deviceId',authMiddleWare,getMetrics)

export default router