--
-- PostgreSQL database cluster dump
--

\restrict rjjx4yy3Exf1mBdzsulqzaf2duSKi2rEmUOg4AsZomNDg3ZmSpCkDVCh40yKudN

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE app;
ALTER ROLE app WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:LmjQGj/TVsoiCj2mc+2qNQ==$B7+4MKmmCCCFS/V8RAOH21p5SNqElhGH0YyxDzBaCYc=:z8CNkLQI75cDG3tbov7L5AJqOqBSaFVPxivIPavLe30=';

--
-- User Configurations
--








\unrestrict rjjx4yy3Exf1mBdzsulqzaf2duSKi2rEmUOg4AsZomNDg3ZmSpCkDVCh40yKudN

--
-- PostgreSQL database cluster dump complete
--

