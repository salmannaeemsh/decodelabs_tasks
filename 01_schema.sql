-- ============================================================
-- DecodeLabs Data Analytics — Project 3: SQL Data Analysis
-- Step 1: Create database and table
-- Run this FIRST in MySQL Workbench
-- ============================================================

CREATE DATABASE IF NOT EXISTS decodelabs_orders;
USE decodelabs_orders;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    OrderID         VARCHAR(20)   PRIMARY KEY,
    OrderDate       DATE          NOT NULL,
    CustomerID      VARCHAR(20)   NOT NULL,
    Product         VARCHAR(50)   NOT NULL,
    Quantity        INT           NOT NULL,
    UnitPrice       DECIMAL(10,2) NOT NULL,
    ShippingAddress VARCHAR(100)  NOT NULL,
    PaymentMethod   VARCHAR(30)   NOT NULL,
    OrderStatus     VARCHAR(20)   NOT NULL,
    TrackingNumber  VARCHAR(20)   NOT NULL,
    ItemsInCart     INT           NOT NULL,
    CouponCode      VARCHAR(20)   NULL,
    ReferralSource  VARCHAR(30)   NOT NULL,
    TotalPrice      DECIMAL(10,2) NOT NULL
);
