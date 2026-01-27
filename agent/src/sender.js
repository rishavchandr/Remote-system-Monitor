import axios from 'axios'
import {CONFIG} from './config.js'

export const sendMetrics = async(payload , retries = 3) => {
  
    try {
        await axios.post(CONFIG.apiUrl,payload,
            {
            headers: {
               'x-device-token': CONFIG.deviceToken,
               'Content-Type': 'application/json'
            },
            timeout: 5000
        })
    } catch (error) {
        if(retries > 0){
            await new Promise(r => setTimeout(r,2000));
            return sendMetrics(payload,retries-1)
        }

        throw error
    }
}