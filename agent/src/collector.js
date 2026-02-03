import si, { battery } from 'systeminformation'
import os, { hostname, platform } from 'os'
import {CONFIG} from './config.js'
import { finished } from 'stream';

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
            cycleCount: b.cycleCount,
            percent:    b.percent
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
        const dockerContainers = await si.dockerAll()
        payload.extras.docker = {
            containerCount: dockerContainers.length,
            containerRunningCount: dockerContainers.filter(c => (c.state === 'running')).length,
            containers: dockerContainers.map(container => ({
                  id: container.id,
                  name: container.name,
                  image: container.image,
                  platform: container.platform,
                  memPercent: container.memPercent || 0,
                  cpuPercent: container.cpuPercent || 0,
                  createdAt: container.createdAt,
                  startedAt: container.startedAt,
                  finishedAt: container.finishedAt,
                  state: container.state,
                  ports: container.ports ? container.ports.map(p =>({
                      public: p.PublicPort,
                      private: p.PrivatePort
                  })) : []
            }))
        }
    }
    
    return payload;
}