import {User} from '../models/user.model.js'
import jwt from 'jsonwebtoken'
import jwtConfig from '../utils/jwtConfig.js'
import bcrypt from 'bcryptjs'
import {asyncHandler} from '../utils/asyncHandler.js'
import {ApiError} from '../utils/ApiError.js'
import {ApiResponse} from '../utils/ApiResponse.js'

export const registerUser = asyncHandler(async(req , res) => {
    const {email,password} = req.body;
    
    if(!email || !password){
        throw new ApiError(400,"Missing fields")
    }

    const existingUser = await User.findOne({ email })
    if(existingUser)
        throw new ApiError(409,"User Already Register")

    const passwordHash = await bcrypt.hash(password,10);

    const user = await User.create({
        email: email.toLowerCase(),
        passwordHash,
    })

    const token = jwt.sign(
        {userId: user._id},
        jwtConfig.secret,
        {expiresIn: jwtConfig.expiresIn}
    )

    user.token = token
    await user.save()

    const createdUser = await User.findById(user._id).select(
        "-passwordHash"
    )

    if(!createdUser)
        throw new ApiError(500,"Something went wrong while registing User")
    
    return res.status(200).json(new ApiResponse(200,createdUser,"User created Successfully"))
})

export const userLogin = asyncHandler(async(req,res) =>{
    const {email,password} = req.body;

    const user = await User.findOne({email})

    if(!user)
        throw new ApiError(401,"User doenot Exists or invaild credentials")

    const isVaild = await bcrypt.compare(password,user.passwordHash)
    if(!isVaild)
        throw new ApiError(401,"invaild credentials")

    const token = jwt.sign(
        {userId: user._id},
        jwtConfig.secret,
        {expiresIn: jwtConfig.expiresIn}
    )

    user.token = token
    await user.save()
    
    return res.status(200).json(new ApiResponse(200,token,"User log in Successfully"))
})

export const logOutUser = asyncHandler(async(req,res) =>{
    
    await User.findByIdAndUpdate(
        req.user_id,
        {
            $set: {
                token: null
            }
        },
        {
                new: true
        }
    )

    return res.status(200).json(new ApiResponse(200,{},"User Logged Out Successfully"))
})