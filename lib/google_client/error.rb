module GoogleClient

  Error = Class.new StandardError
  
  NotFoundError = Class.new Error

  AuthenticationError = Class.new Error

  BadRequestError = Class.new Error

  ConflictError = Class.new Error

end