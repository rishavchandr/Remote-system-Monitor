import jwt from 'jsonwebtoken'
import jwtConfig from '../utils/jwtConfig.js'
import { User } from '../models/user.model.js'
import { asyncHandler } from '../utils/asyncHandler.js'
import { ApiError } from '../utils/ApiError.js'

const authMiddleWare = asyncHandler(async(req,res,next) =>{
    const authHeader = req.headers.authorization

    if(!authHeader)
        throw new ApiError(401,"No user tokens Provided")

    const token = authHeader.split(' ')[1]

    try {
        const decoded = jwt.verify(token,jwtConfig.secret)
        const user = await User.findById(decoded.userId)

        if(!user)
            throw new ApiError(400,"User Invaild Token")

        req.user = user
        next();
        
    } catch {
        throw new ApiError(400,"Invaild Token or Expired")
    }
})

export default authMiddleWare