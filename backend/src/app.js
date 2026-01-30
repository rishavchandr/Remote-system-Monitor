import express from 'express'
import cors from 'cors'

const app = express()

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({
    origin: process.env.CROS_ORIGIN,
}))

app.get('/api/v1/health' , (req,res) =>{
    res.status(200).json({
        status: 'ok',
        uptime: process.uptime()
    })
})

//auth 
import authRouter from './routes/auth.routes.js'
app.use("/api/v1/user/auth" , authRouter)

//devices
import deviceRouter from './routes/device.routes.js'
app.use('/api/v1',deviceRouter)

//metrics
import metricsRouter from './routes/metric.routes.js'

app.use('/api/v1/metrics',metricsRouter)

export {app}
