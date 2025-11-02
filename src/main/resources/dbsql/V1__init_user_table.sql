-- 建议扩展（可选）：UUID 生成 + 大小写不敏感文本
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS citext;

-- 用户表（包含 email、头像、状态、最近登录时间/IP）
CREATE TABLE IF NOT EXISTS "user" (
                                      id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                      username         CITEXT UNIQUE NOT NULL,          -- 用户名（大小写不敏感）
                                      password_hash    TEXT NOT NULL,                   -- BCrypt 哈希
                                      nickname         VARCHAR(32) NOT NULL,
                                      role             VARCHAR(32) NOT NULL DEFAULT 'ROLE_USER',
                                      rating           INT NOT NULL DEFAULT 1500,
                                      coins            INT NOT NULL DEFAULT 0,

                                      email            CITEXT UNIQUE,                   -- 邮箱（大小写不敏感）
                                      avatar_url       TEXT,                            -- 头像
                                      status           SMALLINT NOT NULL DEFAULT 1,     -- 0禁用/1正常/2封禁
                                      last_login_at    TIMESTAMPTZ,                     -- 最近登录时间
                                      last_login_ip    INET,                            -- 最近登录 IP

                                      created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
                                      updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),

                                      CONSTRAINT chk_user_coins_nonneg CHECK (coins >= 0)
);

-- 常用索引（幂等）
CREATE INDEX IF NOT EXISTS idx_user_created_at ON "user"(created_at);
CREATE INDEX IF NOT EXISTS idx_user_status     ON "user"(status);
