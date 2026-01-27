const asyncHandler = (resquestHandle) =>{
    return (req,res,next) =>{
        Promise.resolve(resquestHandle(req,res,next)).catch((err) => next(err))
    }
}

export {asyncHandler}