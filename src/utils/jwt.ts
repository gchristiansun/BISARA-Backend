import jwt, { SignOptions } from "jsonwebtoken";

// Helper var.env
const getEnvVariable = (
    key:
        | 'ACCESSS_TOKEN_SECRET'
        | 'ACCESSS_TOKEN_EXPIRES_IN'
        | 'REFRESH_TOKEN_SECRET'
        | 'REFRESH_TOKEN_EXPIRES_IN'
) : string => {
    const value = process.env[key];
    if (!value) {
        throw new Error(`Missing environment variable: ${key}`);
    }
    return value;
};

// Generate acces token
export const signAccessToken = (payload: string | object | Buffer) : string => {
    const secret = getEnvVariable('ACCESSS_TOKEN_SECRET');
    const expiresIn = getEnvVariable('ACCESSS_TOKEN_EXPIRES_IN')

    const options: SignOptions = { expiresIn: expiresIn as jwt.SignOptions['expiresIn'] };
    return jwt.sign(payload, secret, options);
}

// Generate refresh token
export const signRefreshToken = (payload: string | object | Buffer) : string => {
    const secret = getEnvVariable('REFRESH_TOKEN_SECRET');
    const expiresIn = getEnvVariable('REFRESH_TOKEN_EXPIRES_IN');

    const options: SignOptions = { expiresIn: expiresIn as jwt.SignOptions['expiresIn']};
    return jwt.sign(payload, secret, options)
}

// Verifikasi access token
export const verifyAccessToken = (
    token: string
) : string | jwt.JwtPayload | null => {
    try {
        const secret = getEnvVariable('ACCESSS_TOKEN_SECRET');
        return jwt.verify(token, secret);
    } catch (error) {
        return null;
    }
};

// Verifikasi refresh token
export const verifyRefreshToken = (
    token: string
) : string | jwt.JwtPayload | null => {
    try {
        const secret = getEnvVariable('REFRESH_TOKEN_SECRET');
        return jwt.verify(token, secret)
    } catch (error) {
        return null;
    }
} 