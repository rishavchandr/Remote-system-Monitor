import si, { battery } from 'systeminformation'
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

        battery: await si.battery().then(b =>({
            isCharging: b.isCharging,
            cycleCount: b.cycleCount
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

    if(CONFIG.features.docker){
        const dockerContainers = await si.dockerContainers('all')
        payload.extras.docker = {
            containerCount: dockerContainers.length,
            containers: dockerContainers.map(container => ({
                  id: container.id,
                  name: container.name,
                  image: container.image,
                  state: container.state,
                  ports: container.ports
            }))
        }
    }
    
    return payload;
}