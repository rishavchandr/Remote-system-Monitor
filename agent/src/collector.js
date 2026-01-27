import si from 'systeminformation'
import os, { hostname } from 'os'
import {CONFIG} from './config.js'

export const collectMetrics = async () => {
    const payload = {

        cpu: (await si.currentLoad()).currentLoad,

        memory: await si.mem().then(m =>({
            used: Math.round(m.used/1024/1024),
            total: Math.round(m.total/1024/1024)
        })),

        disk: await si.fsSize().then(d =>({
            used: Math.round(d[0].used/1024/1024),
            total: Math.round(d[0].size/1024/1024)
        })),

        extras: {
            agent: {
                version: CONFIG.agent.version,
                hostname: os.hostname(),
                platform: os.platform()
            }
        }

    };

    if(CONFIG.features.temperature){
        payload.extras.temperature = await si.cpuTemperature()
    }

    if(CONFIG.features.network){
        payload.extras.network = (await si.networkStats())[0]
    }

    return payload;
}