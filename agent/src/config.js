import dotenv from 'dotenv'

dotenv.config({
    path: './env'
})


export const CONFIG = {
    apiUrl: process.env.API_URI ,
    deviceToken: process.env.DEVICE_TOKEN,
    interval: Number(process.env.INTERVAL_MS) || 5000,

    features: {
        temperature: process.env.METRIC_TEMPRATURE,
        network: process.env.METRIC_NETWORK,
        docker: process.env.METRIC_DOCKER
    },

    agent: {
        version: '1.0.0'
    }
}