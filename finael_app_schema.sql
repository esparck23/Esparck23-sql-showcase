-- ============================================================================
-- FinaelApp Database Schema (SQLite)
-- Description: Multi-currency Capital Planning & Projection Engine
-- Author: Daniel José Pacheco Rodríguez
-- ============================================================================

-- Enable Foreign Keys support in SQLite
PRAGMA foreign_keys = ON;

-- 1. ACCOUNTS (Capital Base)
-- Stores the current state of money in different currencies and types.
CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK(type IN ('cash', 'bank', 'crypto')),
    currency TEXT NOT NULL CHECK(currency IN ('USD', 'USDT', 'Bs')),
    balance REAL DEFAULT 0.0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. PROJECTS (Goals & Base Budget)
-- Represents financial goals or the recurring base budget.
CREATE TABLE IF NOT EXISTS projects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    is_base BOOLEAN DEFAULT 0, -- 1 = Base Budget (recurring), 0 = Independent Goal
    goal_amount REAL DEFAULT 0.0,
    total_spent REAL DEFAULT 0.0, -- Accumulator for tracking progress
    currency TEXT DEFAULT 'USD',
    status TEXT DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. CATEGORIES
-- Classification for reporting (Fixed vs Variable expenses).
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    type TEXT DEFAULT 'variable' CHECK(type IN ('fijo', 'variable'))
);

-- 4. INCOMES (Planning Periods)
-- Represents a fiscal period (Month) split into two halves (Q1, Q2).
CREATE TABLE IF NOT EXISTS incomes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    period_name TEXT NOT NULL, -- e.g., "March 2026"
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    amount_q1_bs REAL DEFAULT 0.0,
    amount_q2_bs REAL DEFAULT 0.0,
    rate_q1 REAL, -- Exchange rate used for Q1 projection
    rate_q2 REAL, -- Exchange rate used for Q2 projection
    other_incomes_json TEXT, -- JSON structure for freelance/extra income
    is_active BOOLEAN DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 5. TRANSFERS (Capital Movement)
-- Records currency exchanges (e.g., USDT -> Bs) or movements between accounts.
CREATE TABLE IF NOT EXISTS transfers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    from_account_id INTEGER NOT NULL,
    to_account_id INTEGER NOT NULL,
    amount_from REAL NOT NULL,
    amount_to REAL NOT NULL,
    rate REAL DEFAULT 1.0, -- Conversion rate applied
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_account_id) REFERENCES accounts(id),
    FOREIGN KEY (to_account_id) REFERENCES accounts(id)
);

-- 6. EXPENSES (Transactions)
-- Central table linking money outflow to accounts, projects, and categories.
CREATE TABLE IF NOT EXISTS expenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    concept TEXT NOT NULL,
    amount_bs REAL DEFAULT 0.0,
    amount_usd REAL DEFAULT 0.0,
    rate REAL NOT NULL, -- Mandatory manual rate for valuation consistency
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    account_id INTEGER NOT NULL,
    project_id INTEGER,
    category_id INTEGER,
    income_id INTEGER,
    tags TEXT, -- Comma-separated tags
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (income_id) REFERENCES incomes(id)
);

-- 7. EXCHANGE RATES (History)
-- Log of official rates (BCV) for historical analysis.
CREATE TABLE IF NOT EXISTS exchange_rates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    provider TEXT NOT NULL, -- e.g., 'BCV'
    currency TEXT DEFAULT 'USD',
    rate REAL NOT NULL,
    date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- SEED DATA (For Portfolio Demonstration)
-- ============================================================================

-- Initial Accounts
INSERT INTO accounts (name, type, currency, balance) VALUES 
('Banesco Bs', 'bank', 'Bs', 50000.00),
('Binance USDT', 'crypto', 'USDT', 1200.00),
('Efectivo USD', 'cash', 'USD', 300.00);

-- Categories
INSERT INTO categories (name, type) VALUES 
('Servicios', 'fijo'),
('Alimentación', 'variable'),
('Salud', 'variable'),
('Internet', 'fijo');

-- Projects
INSERT INTO projects (name, description, is_base, goal_amount) VALUES 
('Presupuesto Base', 'Gastos recurrentes mensuales', 1, 0.0),
('Reparación Vehículo', 'Mantenimiento general del carro', 0, 500.0);

-- Active Income Period
INSERT INTO incomes (period_name, start_date, end_date, amount_q1_bs, rate_q1, is_active) VALUES 
('Abril 2026', '2026-04-01 00:00:00', '2026-04-30 23:59:59', 45000.0, 640.0, 1);

-- Sample Transactions
-- 1. Transfer: Sell 100 USDT to Bs at rate 640
INSERT INTO transfers (from_account_id, to_account_id, amount_from, amount_to, rate) 
VALUES (2, 1, 100.0, 64000.0, 640.0);

-- 2. Expense: Pay Internet (Linked to Base Budget)
INSERT INTO expenses (concept, amount_bs, rate, account_id, project_id, category_id, income_id)
VALUES ('Fibra Óptica', 1600.0, 640.0, 1, 1, 4, 1);

-- 3. Expense: Car Part (Linked to Specific Project) using USD Cash
INSERT INTO expenses (concept, amount_usd, rate, account_id, project_id, category_id, income_id)
VALUES ('Repuesto Alternador', 120.0, 1.0, 3, 2, NULL, 1);

-- Indexes for Performance
CREATE INDEX idx_expense_date ON expenses(date);
CREATE INDEX idx_expense_project ON expenses(project_id);
CREATE INDEX idx_income_active ON incomes(is_active);