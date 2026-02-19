--
-- PostgreSQL database dump
--

\restrict TXYaMvTHZhqlrg7wJaCmQ4JvCzuV8wG0bekDT8HCCUaUJGSmLoqyjWmpHzqtU1A

-- Dumped from database version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: accounttype; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.accounttype AS ENUM (
    'REVENUE',
    'EXPENSE',
    'ASSET',
    'LIABILITY',
    'TAX'
);


ALTER TYPE public.accounttype OWNER TO orchid_user;

--
-- Name: categorytype; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.categorytype AS ENUM (
    'RESTAURANT',
    'FACILITY',
    'CUSTOMER_CONSUMABLES',
    'OFFICE',
    'HOTEL_ROOM',
    'FIRE_SAFETY',
    'SECURITY'
);


ALTER TYPE public.categorytype OWNER TO orchid_user;

--
-- Name: grnstatus; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.grnstatus AS ENUM (
    'PENDING',
    'VERIFIED',
    'REJECTED'
);


ALTER TYPE public.grnstatus OWNER TO orchid_user;

--
-- Name: indentstatus; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.indentstatus AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'FULFILLED'
);


ALTER TYPE public.indentstatus OWNER TO orchid_user;

--
-- Name: locationtype; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.locationtype AS ENUM (
    'CENTRAL_WAREHOUSE',
    'BRANCH_STORE',
    'SUB_STORE',
    'GUEST_ROOM',
    'WAREHOUSE',
    'DEPARTMENT',
    'PUBLIC_AREA',
    'LAUNDRY'
);


ALTER TYPE public.locationtype OWNER TO orchid_user;

--
-- Name: notificationtype; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.notificationtype AS ENUM (
    'SERVICE',
    'BOOKING',
    'PACKAGE',
    'INVENTORY',
    'EXPENSE',
    'FOOD_ORDER',
    'SUCCESS',
    'ERROR',
    'INFO'
);


ALTER TYPE public.notificationtype OWNER TO orchid_user;

--
-- Name: postatus; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.postatus AS ENUM (
    'DRAFT',
    'SENT',
    'ACKNOWLEDGED',
    'PARTIALLY_RECEIVED',
    'RECEIVED',
    'CANCELLED'
);


ALTER TYPE public.postatus OWNER TO orchid_user;

--
-- Name: servicestatus; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.servicestatus AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'cancelled'
);


ALTER TYPE public.servicestatus OWNER TO orchid_user;

--
-- Name: stockstate; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.stockstate AS ENUM (
    'IN_ROOM',
    'IN_CLOSET',
    'IN_LAUNDRY',
    'IN_STORE',
    'DAMAGED',
    'LOST'
);


ALTER TYPE public.stockstate OWNER TO orchid_user;

--
-- Name: workorderstatus; Type: TYPE; Schema: public; Owner: orchid_user
--

CREATE TYPE public.workorderstatus AS ENUM (
    'PENDING',
    'ASSIGNED',
    'IN_PROGRESS',
    'WAITING_PARTS',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.workorderstatus OWNER TO orchid_user;

--
-- Name: set_item_id_from_inventory_item_id(); Type: FUNCTION; Schema: public; Owner: orchid_user
--

CREATE FUNCTION public.set_item_id_from_inventory_item_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
                IF NEW.item_id IS NULL AND NEW.inventory_item_id IS NOT NULL THEN
                    NEW.item_id := NEW.inventory_item_id;
                END IF;
                RETURN NEW;
            END;
            $$;


ALTER FUNCTION public.set_item_id_from_inventory_item_id() OWNER TO orchid_user;

--
-- Name: set_uom_from_unit(); Type: FUNCTION; Schema: public; Owner: orchid_user
--

CREATE FUNCTION public.set_uom_from_unit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
                IF NEW.uom IS NULL AND NEW.unit IS NOT NULL THEN
                    NEW.uom := NEW.unit;
                END IF;
                RETURN NEW;
            END;
            $$;


ALTER FUNCTION public.set_uom_from_unit() OWNER TO orchid_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_groups; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.account_groups (
    id integer NOT NULL,
    name character varying NOT NULL,
    account_type public.accounttype NOT NULL,
    description text,
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.account_groups OWNER TO orchid_user;

--
-- Name: account_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.account_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_groups_id_seq OWNER TO orchid_user;

--
-- Name: account_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.account_groups_id_seq OWNED BY public.account_groups.id;


--
-- Name: account_ledgers; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.account_ledgers (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying,
    group_id integer NOT NULL,
    module character varying,
    description text,
    opening_balance double precision,
    balance_type character varying NOT NULL,
    is_active boolean NOT NULL,
    tax_type character varying,
    tax_rate double precision,
    bank_name character varying,
    account_number character varying,
    ifsc_code character varying,
    branch_name character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.account_ledgers OWNER TO orchid_user;

--
-- Name: account_ledgers_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.account_ledgers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_ledgers_id_seq OWNER TO orchid_user;

--
-- Name: account_ledgers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.account_ledgers_id_seq OWNED BY public.account_ledgers.id;


--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.activity_logs (
    id integer NOT NULL,
    action character varying,
    method character varying,
    path character varying,
    status_code integer,
    client_ip character varying,
    user_id integer,
    details text,
    "timestamp" timestamp with time zone DEFAULT now()
);


ALTER TABLE public.activity_logs OWNER TO orchid_user;

--
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.activity_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_logs_id_seq OWNER TO orchid_user;

--
-- Name: activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.activity_logs_id_seq OWNED BY public.activity_logs.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO orchid_user;

--
-- Name: approval_matrices; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.approval_matrices (
    id integer NOT NULL,
    department_id integer,
    approval_type character varying NOT NULL,
    min_amount double precision,
    max_amount double precision,
    level_1_approver_role character varying,
    level_2_approver_role character varying,
    level_3_approver_role character varying,
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.approval_matrices OWNER TO orchid_user;

--
-- Name: approval_matrices_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.approval_matrices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.approval_matrices_id_seq OWNER TO orchid_user;

--
-- Name: approval_matrices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.approval_matrices_id_seq OWNED BY public.approval_matrices.id;


--
-- Name: approval_requests; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.approval_requests (
    id integer NOT NULL,
    request_type character varying NOT NULL,
    reference_id integer NOT NULL,
    reference_type character varying NOT NULL,
    requested_by integer NOT NULL,
    amount double precision,
    current_level integer,
    status character varying,
    level_1_approver integer,
    level_1_status character varying,
    level_1_date timestamp without time zone,
    level_2_approver integer,
    level_2_status character varying,
    level_2_date timestamp without time zone,
    level_3_approver integer,
    level_3_status character varying,
    level_3_date timestamp without time zone,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.approval_requests OWNER TO orchid_user;

--
-- Name: approval_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.approval_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.approval_requests_id_seq OWNER TO orchid_user;

--
-- Name: approval_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.approval_requests_id_seq OWNED BY public.approval_requests.id;


--
-- Name: asset_inspections; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.asset_inspections (
    id integer NOT NULL,
    asset_id integer NOT NULL,
    inspection_date timestamp without time zone,
    inspected_by integer NOT NULL,
    status character varying,
    damage_description text,
    charge_to_guest boolean,
    charge_amount double precision,
    notes text
);


ALTER TABLE public.asset_inspections OWNER TO orchid_user;

--
-- Name: asset_inspections_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.asset_inspections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_inspections_id_seq OWNER TO orchid_user;

--
-- Name: asset_inspections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.asset_inspections_id_seq OWNED BY public.asset_inspections.id;


--
-- Name: asset_maintenance; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.asset_maintenance (
    id integer NOT NULL,
    asset_id integer NOT NULL,
    maintenance_type character varying NOT NULL,
    scheduled_date date,
    completed_date date,
    service_provider character varying,
    cost double precision,
    performed_by integer,
    notes text,
    next_service_due date,
    created_at timestamp without time zone
);


ALTER TABLE public.asset_maintenance OWNER TO orchid_user;

--
-- Name: asset_maintenance_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.asset_maintenance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_maintenance_id_seq OWNER TO orchid_user;

--
-- Name: asset_maintenance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.asset_maintenance_id_seq OWNED BY public.asset_maintenance.id;


--
-- Name: asset_mappings; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.asset_mappings (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    serial_number character varying,
    assigned_date timestamp without time zone NOT NULL,
    assigned_by integer,
    notes text,
    is_active boolean NOT NULL,
    unassigned_date timestamp without time zone,
    quantity double precision DEFAULT '1'::double precision NOT NULL
);


ALTER TABLE public.asset_mappings OWNER TO orchid_user;

--
-- Name: asset_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.asset_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_mappings_id_seq OWNER TO orchid_user;

--
-- Name: asset_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.asset_mappings_id_seq OWNED BY public.asset_mappings.id;


--
-- Name: asset_registry; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.asset_registry (
    id integer NOT NULL,
    asset_tag_id character varying NOT NULL,
    item_id integer NOT NULL,
    serial_number character varying,
    current_location_id integer,
    status character varying NOT NULL,
    purchase_date date,
    warranty_expiry date,
    last_maintenance_date date,
    next_maintenance_due date,
    purchase_master_id integer,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.asset_registry OWNER TO orchid_user;

--
-- Name: asset_registry_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.asset_registry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_registry_id_seq OWNER TO orchid_user;

--
-- Name: asset_registry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.asset_registry_id_seq OWNED BY public.asset_registry.id;


--
-- Name: assigned_services; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.assigned_services (
    id integer NOT NULL,
    service_id integer,
    employee_id integer,
    room_id integer,
    assigned_at timestamp without time zone,
    status public.servicestatus,
    billing_status character varying,
    last_used_at timestamp without time zone,
    override_charges double precision
);


ALTER TABLE public.assigned_services OWNER TO orchid_user;

--
-- Name: assigned_services_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.assigned_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assigned_services_id_seq OWNER TO orchid_user;

--
-- Name: assigned_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.assigned_services_id_seq OWNED BY public.assigned_services.id;


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.attendances (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    date date NOT NULL,
    status character varying NOT NULL
);


ALTER TABLE public.attendances OWNER TO orchid_user;

--
-- Name: attendances_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.attendances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendances_id_seq OWNER TO orchid_user;

--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;


--
-- Name: audit_discrepancies; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.audit_discrepancies (
    id integer NOT NULL,
    audit_id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    system_quantity double precision NOT NULL,
    physical_quantity double precision NOT NULL,
    discrepancy double precision NOT NULL,
    uom character varying NOT NULL,
    resolved_by integer,
    resolved_at timestamp without time zone,
    notes text,
    created_at timestamp without time zone
);


ALTER TABLE public.audit_discrepancies OWNER TO orchid_user;

--
-- Name: audit_discrepancies_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.audit_discrepancies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_discrepancies_id_seq OWNER TO orchid_user;

--
-- Name: audit_discrepancies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.audit_discrepancies_id_seq OWNED BY public.audit_discrepancies.id;


--
-- Name: booking_rooms; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.booking_rooms (
    id integer NOT NULL,
    booking_id integer,
    room_id integer
);


ALTER TABLE public.booking_rooms OWNER TO orchid_user;

--
-- Name: booking_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.booking_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.booking_rooms_id_seq OWNER TO orchid_user;

--
-- Name: booking_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.booking_rooms_id_seq OWNED BY public.booking_rooms.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    status character varying,
    guest_name character varying NOT NULL,
    guest_mobile character varying,
    guest_email character varying,
    check_in date NOT NULL,
    check_out date NOT NULL,
    adults integer,
    children integer,
    id_card_image_url character varying,
    guest_photo_url character varying,
    user_id integer,
    total_amount double precision,
    advance_deposit double precision DEFAULT 0.0,
    checked_in_at timestamp without time zone,
    is_id_verified boolean DEFAULT false,
    package_preferences text,
    digital_signature_url character varying,
    source character varying(255) DEFAULT 'Direct'::character varying,
    package_name character varying(255),
    special_requests text,
    preferences text
);


ALTER TABLE public.bookings OWNER TO orchid_user;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bookings_id_seq OWNER TO orchid_user;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: check_availability; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.check_availability (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100),
    phone character varying(20),
    check_in date,
    check_out date,
    guests integer,
    is_active boolean
);


ALTER TABLE public.check_availability OWNER TO orchid_user;

--
-- Name: check_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.check_availability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.check_availability_id_seq OWNER TO orchid_user;

--
-- Name: check_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.check_availability_id_seq OWNED BY public.check_availability.id;


--
-- Name: checklist_executions; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.checklist_executions (
    id integer NOT NULL,
    checklist_id integer NOT NULL,
    room_id integer,
    location_id integer,
    executed_by integer NOT NULL,
    executed_at timestamp without time zone,
    status character varying,
    completed_at timestamp without time zone,
    notes text
);


ALTER TABLE public.checklist_executions OWNER TO orchid_user;

--
-- Name: checklist_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.checklist_executions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checklist_executions_id_seq OWNER TO orchid_user;

--
-- Name: checklist_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.checklist_executions_id_seq OWNED BY public.checklist_executions.id;


--
-- Name: checklist_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.checklist_items (
    id integer NOT NULL,
    checklist_id integer NOT NULL,
    item_text character varying NOT NULL,
    item_type character varying,
    is_required boolean,
    order_index integer
);


ALTER TABLE public.checklist_items OWNER TO orchid_user;

--
-- Name: checklist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.checklist_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checklist_items_id_seq OWNER TO orchid_user;

--
-- Name: checklist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.checklist_items_id_seq OWNED BY public.checklist_items.id;


--
-- Name: checklist_responses; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.checklist_responses (
    id integer NOT NULL,
    execution_id integer NOT NULL,
    item_id integer NOT NULL,
    response character varying NOT NULL,
    status character varying NOT NULL,
    notes text,
    responded_by integer NOT NULL,
    responded_at timestamp without time zone
);


ALTER TABLE public.checklist_responses OWNER TO orchid_user;

--
-- Name: checklist_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.checklist_responses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checklist_responses_id_seq OWNER TO orchid_user;

--
-- Name: checklist_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.checklist_responses_id_seq OWNED BY public.checklist_responses.id;


--
-- Name: checklists; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.checklists (
    id integer NOT NULL,
    name character varying NOT NULL,
    category character varying NOT NULL,
    module_type character varying NOT NULL,
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.checklists OWNER TO orchid_user;

--
-- Name: checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.checklists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checklists_id_seq OWNER TO orchid_user;

--
-- Name: checklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.checklists_id_seq OWNED BY public.checklists.id;


--
-- Name: checkout_payments; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.checkout_payments (
    id integer NOT NULL,
    checkout_id integer NOT NULL,
    payment_method character varying NOT NULL,
    amount double precision NOT NULL,
    transaction_id character varying,
    notes character varying,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.checkout_payments OWNER TO orchid_user;

--
-- Name: checkout_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.checkout_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checkout_payments_id_seq OWNER TO orchid_user;

--
-- Name: checkout_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.checkout_payments_id_seq OWNED BY public.checkout_payments.id;


--
-- Name: checkout_requests; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.checkout_requests (
    id integer NOT NULL,
    booking_id integer,
    package_booking_id integer,
    room_number character varying NOT NULL,
    guest_name character varying NOT NULL,
    status character varying,
    requested_by character varying,
    requested_at timestamp with time zone DEFAULT now(),
    inventory_checked boolean,
    inventory_checked_by character varying,
    inventory_checked_at timestamp without time zone,
    inventory_notes text,
    checkout_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    employee_id integer,
    completed_at timestamp without time zone,
    inventory_data json
);


ALTER TABLE public.checkout_requests OWNER TO orchid_user;

--
-- Name: checkout_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.checkout_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checkout_requests_id_seq OWNER TO orchid_user;

--
-- Name: checkout_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.checkout_requests_id_seq OWNED BY public.checkout_requests.id;


--
-- Name: checkout_verifications; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.checkout_verifications (
    id integer NOT NULL,
    checkout_id integer NOT NULL,
    room_number character varying NOT NULL,
    housekeeping_status character varying,
    housekeeping_notes text,
    housekeeping_approved_by character varying,
    housekeeping_approved_at timestamp without time zone,
    consumables_audit_data json,
    consumables_total_charge double precision,
    asset_damages json,
    asset_damage_total double precision,
    key_card_returned boolean,
    key_card_fee double precision,
    created_at timestamp with time zone DEFAULT now(),
    checkout_request_id integer
);


ALTER TABLE public.checkout_verifications OWNER TO orchid_user;

--
-- Name: checkout_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.checkout_verifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checkout_verifications_id_seq OWNER TO orchid_user;

--
-- Name: checkout_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.checkout_verifications_id_seq OWNED BY public.checkout_verifications.id;


--
-- Name: checkouts; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.checkouts (
    id integer NOT NULL,
    room_total double precision,
    food_total double precision,
    service_total double precision,
    package_total double precision,
    tax_amount double precision,
    discount_amount double precision,
    grand_total double precision,
    guest_name character varying,
    room_number character varying,
    created_at timestamp with time zone DEFAULT now(),
    checkout_date timestamp without time zone,
    payment_method character varying,
    booking_id integer,
    package_booking_id integer,
    payment_status character varying,
    late_checkout_fee double precision DEFAULT 0.0,
    consumables_charges double precision DEFAULT 0.0,
    asset_damage_charges double precision DEFAULT 0.0,
    key_card_fee double precision DEFAULT 0.0,
    advance_deposit double precision DEFAULT 0.0,
    tips_gratuity double precision DEFAULT 0.0,
    guest_gstin character varying,
    is_b2b boolean DEFAULT false,
    invoice_number character varying,
    invoice_pdf_path character varying,
    gate_pass_path character varying,
    feedback_sent boolean DEFAULT false,
    bill_details json,
    inventory_charges double precision DEFAULT 0.0,
    notes text
);


ALTER TABLE public.checkouts OWNER TO orchid_user;

--
-- Name: checkouts_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.checkouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checkouts_id_seq OWNER TO orchid_user;

--
-- Name: checkouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.checkouts_id_seq OWNED BY public.checkouts.id;


--
-- Name: consumable_usage; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.consumable_usage (
    id integer NOT NULL,
    room_id integer NOT NULL,
    booking_id integer,
    item_id integer NOT NULL,
    quantity_used double precision NOT NULL,
    uom character varying NOT NULL,
    usage_type character varying NOT NULL,
    usage_date timestamp without time zone,
    recorded_by integer NOT NULL,
    charge_amount double precision,
    notes text
);


ALTER TABLE public.consumable_usage OWNER TO orchid_user;

--
-- Name: consumable_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.consumable_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consumable_usage_id_seq OWNER TO orchid_user;

--
-- Name: consumable_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.consumable_usage_id_seq OWNED BY public.consumable_usage.id;


--
-- Name: cost_centers; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.cost_centers (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying,
    description text,
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.cost_centers OWNER TO orchid_user;

--
-- Name: cost_centers_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.cost_centers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cost_centers_id_seq OWNER TO orchid_user;

--
-- Name: cost_centers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.cost_centers_id_seq OWNED BY public.cost_centers.id;


--
-- Name: damage_reports; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.damage_reports (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer,
    room_id integer,
    damage_type character varying NOT NULL,
    description text NOT NULL,
    reported_by integer NOT NULL,
    reported_at timestamp without time zone,
    status character varying,
    approved_by integer,
    approved_at timestamp without time zone,
    resolution_action character varying,
    charge_to_guest boolean,
    charge_amount double precision,
    notes text,
    resolved_at timestamp without time zone
);


ALTER TABLE public.damage_reports OWNER TO orchid_user;

--
-- Name: damage_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.damage_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.damage_reports_id_seq OWNER TO orchid_user;

--
-- Name: damage_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.damage_reports_id_seq OWNED BY public.damage_reports.id;


--
-- Name: employee_inventory_assignments; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.employee_inventory_assignments (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    assigned_service_id integer,
    item_id integer NOT NULL,
    quantity_assigned double precision NOT NULL,
    quantity_used double precision NOT NULL,
    quantity_returned double precision NOT NULL,
    status character varying,
    is_returned boolean,
    assigned_at timestamp without time zone,
    returned_at timestamp without time zone,
    notes character varying
);


ALTER TABLE public.employee_inventory_assignments OWNER TO orchid_user;

--
-- Name: employee_inventory_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.employee_inventory_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_inventory_assignments_id_seq OWNER TO orchid_user;

--
-- Name: employee_inventory_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.employee_inventory_assignments_id_seq OWNED BY public.employee_inventory_assignments.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    name character varying,
    role character varying,
    salary double precision,
    join_date date,
    image_url character varying,
    user_id integer,
    paid_leave_balance integer DEFAULT 12,
    sick_leave_balance integer DEFAULT 12,
    long_leave_balance integer DEFAULT 12,
    wellness_leave_balance integer DEFAULT 12
);


ALTER TABLE public.employees OWNER TO orchid_user;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO orchid_user;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: eod_audit_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.eod_audit_items (
    id integer NOT NULL,
    audit_id integer NOT NULL,
    item_id integer NOT NULL,
    system_quantity double precision NOT NULL,
    physical_quantity double precision NOT NULL,
    variance double precision,
    uom character varying NOT NULL
);


ALTER TABLE public.eod_audit_items OWNER TO orchid_user;

--
-- Name: eod_audit_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.eod_audit_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eod_audit_items_id_seq OWNER TO orchid_user;

--
-- Name: eod_audit_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.eod_audit_items_id_seq OWNED BY public.eod_audit_items.id;


--
-- Name: eod_audits; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.eod_audits (
    id integer NOT NULL,
    audit_date date NOT NULL,
    location_id integer NOT NULL,
    audited_by integer NOT NULL,
    system_stock_value double precision,
    physical_stock_value double precision,
    variance double precision,
    variance_percentage double precision,
    notes text,
    created_at timestamp without time zone
);


ALTER TABLE public.eod_audits OWNER TO orchid_user;

--
-- Name: eod_audits_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.eod_audits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.eod_audits_id_seq OWNER TO orchid_user;

--
-- Name: eod_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.eod_audits_id_seq OWNED BY public.eod_audits.id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.expenses (
    id integer NOT NULL,
    category character varying NOT NULL,
    amount double precision NOT NULL,
    date date NOT NULL,
    description character varying,
    employee_id integer,
    image character varying,
    created_at timestamp without time zone,
    rcm_applicable boolean DEFAULT false NOT NULL,
    rcm_tax_rate double precision,
    nature_of_supply character varying,
    original_bill_no character varying,
    self_invoice_number character varying,
    vendor_id integer,
    rcm_liability_date date,
    itc_eligible boolean DEFAULT true NOT NULL,
    department character varying
);


ALTER TABLE public.expenses OWNER TO orchid_user;

--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.expenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.expenses_id_seq OWNER TO orchid_user;

--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.expenses_id_seq OWNED BY public.expenses.id;


--
-- Name: expiry_alerts; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.expiry_alerts (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    batch_number character varying,
    expiry_date date NOT NULL,
    days_until_expiry integer NOT NULL,
    status character varying,
    created_at timestamp without time zone,
    acknowledged_at timestamp without time zone,
    acknowledged_by integer
);


ALTER TABLE public.expiry_alerts OWNER TO orchid_user;

--
-- Name: expiry_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.expiry_alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.expiry_alerts_id_seq OWNER TO orchid_user;

--
-- Name: expiry_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.expiry_alerts_id_seq OWNED BY public.expiry_alerts.id;


--
-- Name: fire_safety_equipment; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.fire_safety_equipment (
    id integer NOT NULL,
    equipment_type character varying NOT NULL,
    item_id integer,
    asset_id character varying NOT NULL,
    qr_code character varying,
    location_id integer NOT NULL,
    floor character varying,
    zone character varying,
    manufacturer character varying,
    model character varying,
    capacity character varying,
    installation_date date,
    expiry_date date,
    last_inspection_date date,
    next_inspection_date date,
    last_service_date date,
    next_service_date date,
    status character varying,
    certification_number character varying,
    certification_expiry date,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.fire_safety_equipment OWNER TO orchid_user;

--
-- Name: fire_safety_equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.fire_safety_equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fire_safety_equipment_id_seq OWNER TO orchid_user;

--
-- Name: fire_safety_equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.fire_safety_equipment_id_seq OWNED BY public.fire_safety_equipment.id;


--
-- Name: fire_safety_incidents; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.fire_safety_incidents (
    id integer NOT NULL,
    equipment_id integer,
    incident_date timestamp without time zone,
    incident_type character varying NOT NULL,
    location_id integer NOT NULL,
    reported_by integer NOT NULL,
    equipment_used boolean,
    damage_assessment text,
    action_taken text,
    refill_required boolean,
    investigation_report text,
    notes text
);


ALTER TABLE public.fire_safety_incidents OWNER TO orchid_user;

--
-- Name: fire_safety_incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.fire_safety_incidents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fire_safety_incidents_id_seq OWNER TO orchid_user;

--
-- Name: fire_safety_incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.fire_safety_incidents_id_seq OWNED BY public.fire_safety_incidents.id;


--
-- Name: fire_safety_inspections; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.fire_safety_inspections (
    id integer NOT NULL,
    equipment_id integer NOT NULL,
    inspection_date timestamp without time zone,
    inspected_by integer NOT NULL,
    inspection_type character varying NOT NULL,
    status character varying NOT NULL,
    pressure_check character varying,
    visual_check character varying,
    functional_check character varying,
    notes text,
    next_inspection_date date
);


ALTER TABLE public.fire_safety_inspections OWNER TO orchid_user;

--
-- Name: fire_safety_inspections_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.fire_safety_inspections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fire_safety_inspections_id_seq OWNER TO orchid_user;

--
-- Name: fire_safety_inspections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.fire_safety_inspections_id_seq OWNED BY public.fire_safety_inspections.id;


--
-- Name: fire_safety_maintenance; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.fire_safety_maintenance (
    id integer NOT NULL,
    equipment_id integer NOT NULL,
    service_type character varying NOT NULL,
    service_date timestamp without time zone,
    service_provider character varying,
    cost double precision,
    performed_by integer,
    test_certificate_number character varying,
    next_service_due date,
    notes text
);


ALTER TABLE public.fire_safety_maintenance OWNER TO orchid_user;

--
-- Name: fire_safety_maintenance_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.fire_safety_maintenance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fire_safety_maintenance_id_seq OWNER TO orchid_user;

--
-- Name: fire_safety_maintenance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.fire_safety_maintenance_id_seq OWNED BY public.fire_safety_maintenance.id;


--
-- Name: first_aid_kit_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.first_aid_kit_items (
    id integer NOT NULL,
    kit_id integer NOT NULL,
    item_id integer NOT NULL,
    par_quantity integer NOT NULL,
    current_quantity integer,
    expiry_date date,
    last_restocked date
);


ALTER TABLE public.first_aid_kit_items OWNER TO orchid_user;

--
-- Name: first_aid_kit_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.first_aid_kit_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.first_aid_kit_items_id_seq OWNER TO orchid_user;

--
-- Name: first_aid_kit_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.first_aid_kit_items_id_seq OWNED BY public.first_aid_kit_items.id;


--
-- Name: first_aid_kits; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.first_aid_kits (
    id integer NOT NULL,
    kit_number character varying NOT NULL,
    location_id integer NOT NULL,
    last_checked_date date,
    next_check_date date,
    expiry_items_count integer,
    status character varying,
    checked_by integer,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.first_aid_kits OWNER TO orchid_user;

--
-- Name: first_aid_kits_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.first_aid_kits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.first_aid_kits_id_seq OWNER TO orchid_user;

--
-- Name: first_aid_kits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.first_aid_kits_id_seq OWNED BY public.first_aid_kits.id;


--
-- Name: food_categories; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.food_categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    image character varying
);


ALTER TABLE public.food_categories OWNER TO orchid_user;

--
-- Name: food_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.food_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_categories_id_seq OWNER TO orchid_user;

--
-- Name: food_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.food_categories_id_seq OWNED BY public.food_categories.id;


--
-- Name: food_item_images; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.food_item_images (
    id integer NOT NULL,
    image_url character varying,
    item_id integer
);


ALTER TABLE public.food_item_images OWNER TO orchid_user;

--
-- Name: food_item_images_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.food_item_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_item_images_id_seq OWNER TO orchid_user;

--
-- Name: food_item_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.food_item_images_id_seq OWNED BY public.food_item_images.id;


--
-- Name: food_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.food_items (
    id integer NOT NULL,
    name character varying,
    description character varying,
    price integer,
    available character varying,
    category_id integer
);


ALTER TABLE public.food_items OWNER TO orchid_user;

--
-- Name: food_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.food_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_items_id_seq OWNER TO orchid_user;

--
-- Name: food_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.food_items_id_seq OWNED BY public.food_items.id;


--
-- Name: food_order_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.food_order_items (
    id integer NOT NULL,
    order_id integer,
    food_item_id integer,
    quantity integer
);


ALTER TABLE public.food_order_items OWNER TO orchid_user;

--
-- Name: food_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.food_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_order_items_id_seq OWNER TO orchid_user;

--
-- Name: food_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.food_order_items_id_seq OWNED BY public.food_order_items.id;


--
-- Name: food_orders; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.food_orders (
    id integer NOT NULL,
    room_id integer,
    amount double precision,
    assigned_employee_id integer,
    status character varying,
    billing_status character varying,
    created_at timestamp without time zone,
    order_type character varying DEFAULT 'dine_in'::character varying,
    delivery_request text,
    payment_method character varying,
    payment_time timestamp without time zone,
    gst_amount double precision,
    total_with_gst double precision,
    is_deleted boolean DEFAULT false NOT NULL,
    created_by_id integer,
    prepared_by_id integer
);


ALTER TABLE public.food_orders OWNER TO orchid_user;

--
-- Name: food_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.food_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_orders_id_seq OWNER TO orchid_user;

--
-- Name: food_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.food_orders_id_seq OWNED BY public.food_orders.id;


--
-- Name: gallery; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.gallery (
    id integer NOT NULL,
    image_url character varying(255),
    caption character varying(255),
    is_active boolean
);


ALTER TABLE public.gallery OWNER TO orchid_user;

--
-- Name: gallery_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.gallery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gallery_id_seq OWNER TO orchid_user;

--
-- Name: gallery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.gallery_id_seq OWNED BY public.gallery.id;


--
-- Name: goods_received_notes; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.goods_received_notes (
    id integer NOT NULL,
    grn_number character varying NOT NULL,
    po_id integer NOT NULL,
    received_by integer NOT NULL,
    verified_by integer,
    status public.grnstatus,
    received_date timestamp without time zone,
    verified_date timestamp without time zone,
    notes text
);


ALTER TABLE public.goods_received_notes OWNER TO orchid_user;

--
-- Name: goods_received_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.goods_received_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.goods_received_notes_id_seq OWNER TO orchid_user;

--
-- Name: goods_received_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.goods_received_notes_id_seq OWNED BY public.goods_received_notes.id;


--
-- Name: grn_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.grn_items (
    id integer NOT NULL,
    grn_id integer NOT NULL,
    po_item_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    expiry_date date,
    batch_number character varying,
    unit_price double precision NOT NULL,
    location_id integer NOT NULL,
    barcode_generated boolean
);


ALTER TABLE public.grn_items OWNER TO orchid_user;

--
-- Name: grn_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.grn_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grn_items_id_seq OWNER TO orchid_user;

--
-- Name: grn_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.grn_items_id_seq OWNED BY public.grn_items.id;


--
-- Name: guest_suggestions; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.guest_suggestions (
    id integer NOT NULL,
    guest_name character varying(100) NOT NULL,
    contact_info character varying(100),
    suggestion text NOT NULL,
    status character varying(50),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.guest_suggestions OWNER TO orchid_user;

--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.guest_suggestions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guest_suggestions_id_seq OWNER TO orchid_user;

--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.guest_suggestions_id_seq OWNED BY public.guest_suggestions.id;


--
-- Name: header_banner; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.header_banner (
    id integer NOT NULL,
    title character varying(255),
    subtitle text,
    image_url character varying(255),
    is_active boolean
);


ALTER TABLE public.header_banner OWNER TO orchid_user;

--
-- Name: header_banner_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.header_banner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.header_banner_id_seq OWNER TO orchid_user;

--
-- Name: header_banner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.header_banner_id_seq OWNED BY public.header_banner.id;


--
-- Name: indent_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.indent_items (
    id integer NOT NULL,
    indent_id integer NOT NULL,
    item_id integer NOT NULL,
    requested_quantity double precision NOT NULL,
    approved_quantity double precision,
    issued_quantity double precision,
    uom character varying NOT NULL,
    notes text
);


ALTER TABLE public.indent_items OWNER TO orchid_user;

--
-- Name: indent_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.indent_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.indent_items_id_seq OWNER TO orchid_user;

--
-- Name: indent_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.indent_items_id_seq OWNED BY public.indent_items.id;


--
-- Name: indents; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.indents (
    id integer NOT NULL,
    indent_number character varying NOT NULL,
    requested_from_location_id integer NOT NULL,
    requested_to_location_id integer NOT NULL,
    status public.indentstatus,
    requested_by integer NOT NULL,
    approved_by integer,
    requested_date timestamp without time zone,
    approved_date timestamp without time zone,
    fulfilled_date timestamp without time zone,
    notes text
);


ALTER TABLE public.indents OWNER TO orchid_user;

--
-- Name: indents_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.indents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.indents_id_seq OWNER TO orchid_user;

--
-- Name: indents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.indents_id_seq OWNED BY public.indents.id;


--
-- Name: inventory_categories; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.inventory_categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    parent_department character varying,
    gst_tax_rate double precision DEFAULT 0.0,
    is_perishable boolean DEFAULT false,
    is_asset_fixed boolean DEFAULT false,
    is_sellable boolean DEFAULT false,
    track_laundry boolean DEFAULT false,
    allow_partial_usage boolean DEFAULT false,
    consumable_instant boolean DEFAULT false,
    classification character varying,
    hsn_sac_code character varying,
    default_gst_rate double precision DEFAULT 0.0,
    cess_percentage double precision DEFAULT 0.0,
    itc_eligibility character varying DEFAULT 'Eligible'::character varying,
    is_capital_good boolean DEFAULT false
);


ALTER TABLE public.inventory_categories OWNER TO orchid_user;

--
-- Name: inventory_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.inventory_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_categories_id_seq OWNER TO orchid_user;

--
-- Name: inventory_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.inventory_categories_id_seq OWNED BY public.inventory_categories.id;


--
-- Name: inventory_expenses; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.inventory_expenses (
    id integer NOT NULL,
    item_id integer NOT NULL,
    cost_center_id integer NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    unit_cost double precision NOT NULL,
    total_cost double precision NOT NULL,
    issued_to character varying,
    issued_by integer NOT NULL,
    issued_date timestamp without time zone,
    notes text
);


ALTER TABLE public.inventory_expenses OWNER TO orchid_user;

--
-- Name: inventory_expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.inventory_expenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_expenses_id_seq OWNER TO orchid_user;

--
-- Name: inventory_expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.inventory_expenses_id_seq OWNED BY public.inventory_expenses.id;


--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.inventory_items (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    category_id integer NOT NULL,
    sku character varying,
    barcode character varying,
    base_uom_id integer,
    unit_price double precision,
    selling_price double precision,
    track_expiry boolean,
    track_serial boolean,
    track_batch boolean,
    min_stock_level double precision,
    max_stock_level double precision,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    hsn_code character varying,
    gst_rate double precision DEFAULT 0,
    item_code character varying,
    sub_category character varying,
    image_path character varying,
    location character varying,
    track_serial_number boolean DEFAULT false,
    is_sellable_to_guest boolean DEFAULT false,
    track_laundry_cycle boolean DEFAULT false,
    is_asset_fixed boolean DEFAULT false,
    maintenance_schedule_days integer,
    complimentary_limit integer,
    ingredient_yield_percentage double precision,
    preferred_vendor_id integer,
    vendor_item_code character varying,
    lead_time_days integer,
    is_perishable boolean DEFAULT false,
    unit character varying DEFAULT 'pcs'::character varying NOT NULL,
    current_stock double precision DEFAULT 0.0 NOT NULL
);


ALTER TABLE public.inventory_items OWNER TO orchid_user;

--
-- Name: inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.inventory_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_items_id_seq OWNER TO orchid_user;

--
-- Name: inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.inventory_items_id_seq OWNED BY public.inventory_items.id;


--
-- Name: inventory_transactions; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.inventory_transactions (
    id integer NOT NULL,
    item_id integer NOT NULL,
    transaction_type character varying NOT NULL,
    quantity double precision NOT NULL,
    unit_price double precision,
    total_amount double precision,
    reference_number character varying,
    purchase_master_id integer,
    notes text,
    created_by integer,
    created_at timestamp without time zone NOT NULL,
    department character varying
);


ALTER TABLE public.inventory_transactions OWNER TO orchid_user;

--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.inventory_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_transactions_id_seq OWNER TO orchid_user;

--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.inventory_transactions_id_seq OWNED BY public.inventory_transactions.id;


--
-- Name: journal_entries; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.journal_entries (
    id integer NOT NULL,
    entry_number character varying NOT NULL,
    entry_date timestamp with time zone DEFAULT now() NOT NULL,
    reference_type character varying,
    reference_id integer,
    description text NOT NULL,
    total_amount double precision NOT NULL,
    created_by integer,
    notes text,
    is_reversed boolean,
    reversed_entry_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.journal_entries OWNER TO orchid_user;

--
-- Name: journal_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.journal_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_entries_id_seq OWNER TO orchid_user;

--
-- Name: journal_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.journal_entries_id_seq OWNED BY public.journal_entries.id;


--
-- Name: journal_entry_lines; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.journal_entry_lines (
    id integer NOT NULL,
    entry_id integer NOT NULL,
    debit_ledger_id integer,
    credit_ledger_id integer,
    amount double precision NOT NULL,
    description text,
    line_number integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.journal_entry_lines OWNER TO orchid_user;

--
-- Name: journal_entry_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.journal_entry_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_entry_lines_id_seq OWNER TO orchid_user;

--
-- Name: journal_entry_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.journal_entry_lines_id_seq OWNED BY public.journal_entry_lines.id;


--
-- Name: key_management; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.key_management (
    id integer NOT NULL,
    key_number character varying NOT NULL,
    key_type character varying NOT NULL,
    location_id integer,
    room_id integer,
    description text,
    current_holder integer,
    status character varying,
    issued_date timestamp without time zone,
    returned_date timestamp without time zone,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.key_management OWNER TO orchid_user;

--
-- Name: key_management_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.key_management_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.key_management_id_seq OWNER TO orchid_user;

--
-- Name: key_management_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.key_management_id_seq OWNED BY public.key_management.id;


--
-- Name: key_movements; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.key_movements (
    id integer NOT NULL,
    key_id integer NOT NULL,
    movement_type character varying NOT NULL,
    from_user_id integer,
    to_user_id integer,
    purpose text,
    movement_date timestamp without time zone,
    returned_date timestamp without time zone,
    notes text
);


ALTER TABLE public.key_movements OWNER TO orchid_user;

--
-- Name: key_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.key_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.key_movements_id_seq OWNER TO orchid_user;

--
-- Name: key_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.key_movements_id_seq OWNED BY public.key_movements.id;


--
-- Name: laundry_logs; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.laundry_logs (
    id integer NOT NULL,
    item_id integer NOT NULL,
    source_location_id integer,
    room_number character varying,
    quantity double precision NOT NULL,
    status character varying NOT NULL,
    sent_at timestamp without time zone,
    washed_at timestamp without time zone,
    returned_at timestamp without time zone,
    created_by integer,
    notes text
);


ALTER TABLE public.laundry_logs OWNER TO orchid_user;

--
-- Name: laundry_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.laundry_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.laundry_logs_id_seq OWNER TO orchid_user;

--
-- Name: laundry_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.laundry_logs_id_seq OWNED BY public.laundry_logs.id;


--
-- Name: laundry_services; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.laundry_services (
    id integer NOT NULL,
    vendor_id integer,
    name character varying NOT NULL,
    contact_person character varying,
    phone character varying,
    email character varying,
    rate_per_kg double precision,
    rate_per_piece double precision,
    turnaround_time_days integer,
    is_active boolean,
    notes text,
    created_at timestamp without time zone
);


ALTER TABLE public.laundry_services OWNER TO orchid_user;

--
-- Name: laundry_services_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.laundry_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.laundry_services_id_seq OWNER TO orchid_user;

--
-- Name: laundry_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.laundry_services_id_seq OWNED BY public.laundry_services.id;


--
-- Name: leaves; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.leaves (
    id integer NOT NULL,
    employee_id integer,
    from_date date,
    to_date date,
    reason character varying,
    leave_type character varying,
    status character varying
);


ALTER TABLE public.leaves OWNER TO orchid_user;

--
-- Name: leaves_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.leaves_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leaves_id_seq OWNER TO orchid_user;

--
-- Name: leaves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.leaves_id_seq OWNED BY public.leaves.id;


--
-- Name: legal_documents; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.legal_documents (
    id integer NOT NULL,
    name character varying NOT NULL,
    document_type character varying,
    file_path character varying NOT NULL,
    uploaded_at timestamp with time zone DEFAULT now(),
    description character varying
);


ALTER TABLE public.legal_documents OWNER TO orchid_user;

--
-- Name: legal_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.legal_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.legal_documents_id_seq OWNER TO orchid_user;

--
-- Name: legal_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.legal_documents_id_seq OWNED BY public.legal_documents.id;


--
-- Name: linen_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.linen_items (
    id integer NOT NULL,
    item_id integer NOT NULL,
    rfid_tag character varying,
    barcode character varying,
    quality_grade character varying,
    wash_count integer,
    max_washes integer,
    current_state public.stockstate,
    current_location_id integer,
    current_room_id integer,
    purchase_date date,
    first_use_date date,
    discard_date date,
    discard_reason character varying,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.linen_items OWNER TO orchid_user;

--
-- Name: linen_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.linen_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.linen_items_id_seq OWNER TO orchid_user;

--
-- Name: linen_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.linen_items_id_seq OWNED BY public.linen_items.id;


--
-- Name: linen_movements; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.linen_movements (
    id integer NOT NULL,
    item_id integer NOT NULL,
    room_id integer,
    from_state public.stockstate,
    to_state public.stockstate NOT NULL,
    quantity integer NOT NULL,
    movement_date timestamp without time zone,
    moved_by integer NOT NULL,
    notes text
);


ALTER TABLE public.linen_movements OWNER TO orchid_user;

--
-- Name: linen_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.linen_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.linen_movements_id_seq OWNER TO orchid_user;

--
-- Name: linen_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.linen_movements_id_seq OWNED BY public.linen_movements.id;


--
-- Name: linen_stocks; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.linen_stocks (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    state public.stockstate NOT NULL,
    quantity integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.linen_stocks OWNER TO orchid_user;

--
-- Name: linen_stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.linen_stocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.linen_stocks_id_seq OWNER TO orchid_user;

--
-- Name: linen_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.linen_stocks_id_seq OWNED BY public.linen_stocks.id;


--
-- Name: linen_wash_logs; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.linen_wash_logs (
    id integer NOT NULL,
    linen_item_id integer NOT NULL,
    wash_date timestamp without time zone,
    wash_count_after integer NOT NULL,
    quality_after character varying,
    laundry_provider character varying,
    cost double precision,
    notes text
);


ALTER TABLE public.linen_wash_logs OWNER TO orchid_user;

--
-- Name: linen_wash_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.linen_wash_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.linen_wash_logs_id_seq OWNER TO orchid_user;

--
-- Name: linen_wash_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.linen_wash_logs_id_seq OWNED BY public.linen_wash_logs.id;


--
-- Name: location_stocks; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.location_stocks (
    id integer NOT NULL,
    location_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity double precision NOT NULL,
    last_updated timestamp without time zone
);


ALTER TABLE public.location_stocks OWNER TO orchid_user;

--
-- Name: location_stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.location_stocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_stocks_id_seq OWNER TO orchid_user;

--
-- Name: location_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.location_stocks_id_seq OWNED BY public.location_stocks.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying,
    location_type public.locationtype NOT NULL,
    parent_location_id integer,
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    location_code character varying,
    is_inventory_point boolean DEFAULT false,
    building character varying DEFAULT 'Main Block'::character varying NOT NULL,
    floor character varying,
    room_area character varying DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.locations OWNER TO orchid_user;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.locations_id_seq OWNER TO orchid_user;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: lost_found; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.lost_found (
    id integer NOT NULL,
    item_description text NOT NULL,
    found_date date NOT NULL,
    found_by character varying,
    found_by_employee_id integer,
    room_number character varying,
    location character varying,
    status character varying NOT NULL,
    claimed_by character varying,
    claimed_date date,
    claimed_contact character varying,
    notes text,
    image_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.lost_found OWNER TO orchid_user;

--
-- Name: lost_found_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.lost_found_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lost_found_id_seq OWNER TO orchid_user;

--
-- Name: lost_found_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.lost_found_id_seq OWNED BY public.lost_found.id;


--
-- Name: maintenance_tickets; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.maintenance_tickets (
    id integer NOT NULL,
    title character varying NOT NULL,
    description text NOT NULL,
    category character varying NOT NULL,
    item_id integer,
    location_id integer,
    room_id integer,
    priority character varying,
    status character varying,
    reported_by integer NOT NULL,
    assigned_to integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    resolution_notes text,
    completed_at timestamp without time zone
);


ALTER TABLE public.maintenance_tickets OWNER TO orchid_user;

--
-- Name: maintenance_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.maintenance_tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.maintenance_tickets_id_seq OWNER TO orchid_user;

--
-- Name: maintenance_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.maintenance_tickets_id_seq OWNED BY public.maintenance_tickets.id;


--
-- Name: nearby_attraction_banners; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.nearby_attraction_banners (
    id integer NOT NULL,
    title character varying(255),
    subtitle text,
    image_url character varying(255),
    is_active boolean,
    map_link character varying(512)
);


ALTER TABLE public.nearby_attraction_banners OWNER TO orchid_user;

--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.nearby_attraction_banners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nearby_attraction_banners_id_seq OWNER TO orchid_user;

--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.nearby_attraction_banners_id_seq OWNED BY public.nearby_attraction_banners.id;


--
-- Name: nearby_attractions; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.nearby_attractions (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    is_active boolean,
    map_link character varying(512)
);


ALTER TABLE public.nearby_attractions OWNER TO orchid_user;

--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.nearby_attractions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nearby_attractions_id_seq OWNER TO orchid_user;

--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.nearby_attractions_id_seq OWNED BY public.nearby_attractions.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    type public.notificationtype NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    is_read boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    read_at timestamp with time zone,
    entity_type character varying(50),
    entity_id integer,
    recipient_id integer
);


ALTER TABLE public.notifications OWNER TO orchid_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO orchid_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: office_inventory_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.office_inventory_items (
    id integer NOT NULL,
    item_id integer NOT NULL,
    item_type character varying NOT NULL,
    department_id integer,
    location_id integer,
    assigned_to integer,
    asset_tag character varying,
    serial_number character varying,
    purchase_date date,
    purchase_price double precision,
    warranty_expiry date,
    amc_expiry date,
    status character varying,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.office_inventory_items OWNER TO orchid_user;

--
-- Name: office_inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.office_inventory_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.office_inventory_items_id_seq OWNER TO orchid_user;

--
-- Name: office_inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.office_inventory_items_id_seq OWNED BY public.office_inventory_items.id;


--
-- Name: office_requisitions; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.office_requisitions (
    id integer NOT NULL,
    req_number character varying NOT NULL,
    item_id integer NOT NULL,
    requested_by integer NOT NULL,
    department_id integer NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    purpose text,
    status character varying,
    supervisor_approval integer,
    admin_approval integer,
    approved_date timestamp without time zone,
    issued_date timestamp without time zone,
    issued_by integer,
    notes text,
    created_at timestamp without time zone
);


ALTER TABLE public.office_requisitions OWNER TO orchid_user;

--
-- Name: office_requisitions_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.office_requisitions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.office_requisitions_id_seq OWNER TO orchid_user;

--
-- Name: office_requisitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.office_requisitions_id_seq OWNED BY public.office_requisitions.id;


--
-- Name: outlet_stocks; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.outlet_stocks (
    id integer NOT NULL,
    outlet_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity double precision,
    uom character varying NOT NULL,
    par_level double precision,
    last_updated timestamp without time zone
);


ALTER TABLE public.outlet_stocks OWNER TO orchid_user;

--
-- Name: outlet_stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.outlet_stocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.outlet_stocks_id_seq OWNER TO orchid_user;

--
-- Name: outlet_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.outlet_stocks_id_seq OWNED BY public.outlet_stocks.id;


--
-- Name: outlets; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.outlets (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying,
    location_id integer,
    outlet_type character varying NOT NULL,
    is_active boolean,
    description text,
    created_at timestamp without time zone
);


ALTER TABLE public.outlets OWNER TO orchid_user;

--
-- Name: outlets_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.outlets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.outlets_id_seq OWNER TO orchid_user;

--
-- Name: outlets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.outlets_id_seq OWNED BY public.outlets.id;


--
-- Name: package_booking_rooms; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.package_booking_rooms (
    id integer NOT NULL,
    package_booking_id integer,
    room_id integer
);


ALTER TABLE public.package_booking_rooms OWNER TO orchid_user;

--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.package_booking_rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.package_booking_rooms_id_seq OWNER TO orchid_user;

--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.package_booking_rooms_id_seq OWNED BY public.package_booking_rooms.id;


--
-- Name: package_bookings; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.package_bookings (
    id integer NOT NULL,
    package_id integer,
    user_id integer,
    guest_name character varying NOT NULL,
    guest_email character varying,
    guest_mobile character varying,
    check_in date NOT NULL,
    check_out date NOT NULL,
    adults integer,
    children integer,
    id_card_image_url character varying,
    guest_photo_url character varying,
    status character varying,
    advance_deposit double precision DEFAULT 0.0,
    checked_in_at timestamp without time zone,
    food_preferences text,
    special_requests text,
    total_amount double precision DEFAULT 0.0
);


ALTER TABLE public.package_bookings OWNER TO orchid_user;

--
-- Name: package_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.package_bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.package_bookings_id_seq OWNER TO orchid_user;

--
-- Name: package_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.package_bookings_id_seq OWNED BY public.package_bookings.id;


--
-- Name: package_images; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.package_images (
    id integer NOT NULL,
    package_id integer,
    image_url character varying NOT NULL
);


ALTER TABLE public.package_images OWNER TO orchid_user;

--
-- Name: package_images_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.package_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.package_images_id_seq OWNER TO orchid_user;

--
-- Name: package_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.package_images_id_seq OWNED BY public.package_images.id;


--
-- Name: packages; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.packages (
    id integer NOT NULL,
    title character varying NOT NULL,
    description character varying,
    price double precision NOT NULL,
    booking_type character varying,
    room_types character varying,
    theme character varying,
    default_adults integer DEFAULT 2,
    default_children integer DEFAULT 0,
    max_stay_days integer,
    food_included character varying,
    food_timing character varying,
    complimentary text,
    status character varying DEFAULT 'active'::character varying
);


ALTER TABLE public.packages OWNER TO orchid_user;

--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.packages_id_seq OWNER TO orchid_user;

--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.packages_id_seq OWNED BY public.packages.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    booking_id integer,
    amount double precision,
    method character varying,
    status character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.payments OWNER TO orchid_user;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO orchid_user;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: perishable_batches; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.perishable_batches (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    batch_number character varying NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    expiry_date date NOT NULL,
    received_date date,
    created_at timestamp without time zone
);


ALTER TABLE public.perishable_batches OWNER TO orchid_user;

--
-- Name: perishable_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.perishable_batches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.perishable_batches_id_seq OWNER TO orchid_user;

--
-- Name: perishable_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.perishable_batches_id_seq OWNED BY public.perishable_batches.id;


--
-- Name: plan_weddings; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.plan_weddings (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    is_active boolean
);


ALTER TABLE public.plan_weddings OWNER TO orchid_user;

--
-- Name: plan_weddings_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.plan_weddings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plan_weddings_id_seq OWNER TO orchid_user;

--
-- Name: plan_weddings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.plan_weddings_id_seq OWNED BY public.plan_weddings.id;


--
-- Name: po_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.po_items (
    id integer NOT NULL,
    po_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    unit_price double precision NOT NULL,
    total_price double precision NOT NULL,
    received_quantity double precision
);


ALTER TABLE public.po_items OWNER TO orchid_user;

--
-- Name: po_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.po_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.po_items_id_seq OWNER TO orchid_user;

--
-- Name: po_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.po_items_id_seq OWNED BY public.po_items.id;


--
-- Name: purchase_details; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.purchase_details (
    id integer NOT NULL,
    purchase_master_id integer NOT NULL,
    item_id integer NOT NULL,
    hsn_code character varying,
    quantity double precision NOT NULL,
    unit character varying NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    gst_rate numeric(5,2) NOT NULL,
    cgst_amount numeric(10,2) NOT NULL,
    sgst_amount numeric(10,2) NOT NULL,
    igst_amount numeric(10,2) NOT NULL,
    discount numeric(10,2) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    notes text
);


ALTER TABLE public.purchase_details OWNER TO orchid_user;

--
-- Name: purchase_details_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.purchase_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_details_id_seq OWNER TO orchid_user;

--
-- Name: purchase_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.purchase_details_id_seq OWNED BY public.purchase_details.id;


--
-- Name: purchase_entries; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.purchase_entries (
    id integer NOT NULL,
    entry_number character varying NOT NULL,
    invoice_number character varying NOT NULL,
    invoice_date date NOT NULL,
    vendor_id integer NOT NULL,
    vendor_address text,
    vendor_gstin character varying,
    tax_inclusive boolean,
    taxable_amount double precision,
    total_gst_amount double precision,
    total_invoice_value double precision,
    status character varying,
    location_id integer NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    notes text
);


ALTER TABLE public.purchase_entries OWNER TO orchid_user;

--
-- Name: purchase_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.purchase_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_entries_id_seq OWNER TO orchid_user;

--
-- Name: purchase_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.purchase_entries_id_seq OWNED BY public.purchase_entries.id;


--
-- Name: purchase_entry_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.purchase_entry_items (
    id integer NOT NULL,
    purchase_entry_id integer NOT NULL,
    item_id integer NOT NULL,
    hsn_code character varying,
    uom character varying NOT NULL,
    gst_rate double precision,
    quantity double precision NOT NULL,
    rate double precision NOT NULL,
    base_amount double precision NOT NULL,
    gst_amount double precision,
    total_amount double precision NOT NULL,
    stock_updated boolean,
    stock_level_id integer
);


ALTER TABLE public.purchase_entry_items OWNER TO orchid_user;

--
-- Name: purchase_entry_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.purchase_entry_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_entry_items_id_seq OWNER TO orchid_user;

--
-- Name: purchase_entry_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.purchase_entry_items_id_seq OWNED BY public.purchase_entry_items.id;


--
-- Name: purchase_masters; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.purchase_masters (
    id integer NOT NULL,
    purchase_number character varying NOT NULL,
    vendor_id integer NOT NULL,
    purchase_date date NOT NULL,
    expected_delivery_date date,
    invoice_number character varying,
    invoice_date date,
    gst_number character varying,
    payment_terms character varying,
    payment_status character varying NOT NULL,
    sub_total numeric(10,2) NOT NULL,
    cgst numeric(10,2) NOT NULL,
    sgst numeric(10,2) NOT NULL,
    igst numeric(10,2) NOT NULL,
    discount numeric(10,2) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    notes text,
    status character varying NOT NULL,
    created_by integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    payment_method character varying,
    destination_location_id integer
);


ALTER TABLE public.purchase_masters OWNER TO orchid_user;

--
-- Name: purchase_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.purchase_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_masters_id_seq OWNER TO orchid_user;

--
-- Name: purchase_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.purchase_masters_id_seq OWNED BY public.purchase_masters.id;


--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.purchase_orders (
    id integer NOT NULL,
    po_number character varying NOT NULL,
    indent_id integer,
    vendor_name character varying NOT NULL,
    vendor_email character varying,
    vendor_phone character varying,
    status public.postatus,
    total_amount double precision,
    created_by integer NOT NULL,
    approved_by integer,
    created_at timestamp without time zone,
    sent_at timestamp without time zone,
    expected_delivery_date date,
    notes text
);


ALTER TABLE public.purchase_orders OWNER TO orchid_user;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.purchase_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_orders_id_seq OWNER TO orchid_user;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.purchase_orders_id_seq OWNED BY public.purchase_orders.id;


--
-- Name: recipe_ingredients; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.recipe_ingredients (
    id integer NOT NULL,
    recipe_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    quantity double precision NOT NULL,
    unit character varying NOT NULL,
    notes character varying,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text)
);


ALTER TABLE public.recipe_ingredients OWNER TO orchid_user;

--
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.recipe_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipe_ingredients_id_seq OWNER TO orchid_user;

--
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.recipe_ingredients_id_seq OWNED BY public.recipe_ingredients.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.recipes (
    id integer NOT NULL,
    food_item_id integer NOT NULL,
    name character varying NOT NULL,
    description text,
    servings integer DEFAULT 1,
    prep_time_minutes integer,
    cook_time_minutes integer,
    created_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_at timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc'::text)
);


ALTER TABLE public.recipes OWNER TO orchid_user;

--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipes_id_seq OWNER TO orchid_user;

--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: resort_info; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.resort_info (
    id integer NOT NULL,
    name character varying(255),
    address text,
    facebook character varying(255),
    instagram character varying(255),
    twitter character varying(255),
    linkedin character varying(255),
    is_active boolean
);


ALTER TABLE public.resort_info OWNER TO orchid_user;

--
-- Name: resort_info_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.resort_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resort_info_id_seq OWNER TO orchid_user;

--
-- Name: resort_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.resort_info_id_seq OWNED BY public.resort_info.id;


--
-- Name: restock_alerts; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.restock_alerts (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    current_stock double precision NOT NULL,
    min_stock double precision NOT NULL,
    alert_type character varying NOT NULL,
    status character varying,
    created_at timestamp without time zone,
    acknowledged_at timestamp without time zone,
    acknowledged_by integer,
    resolved_at timestamp without time zone,
    resolved_by integer,
    notes text
);


ALTER TABLE public.restock_alerts OWNER TO orchid_user;

--
-- Name: restock_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.restock_alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restock_alerts_id_seq OWNER TO orchid_user;

--
-- Name: restock_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.restock_alerts_id_seq OWNED BY public.restock_alerts.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    name character varying(100),
    comment text,
    rating integer,
    is_active boolean
);


ALTER TABLE public.reviews OWNER TO orchid_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_id_seq OWNER TO orchid_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying,
    permissions text
);


ALTER TABLE public.roles OWNER TO orchid_user;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO orchid_user;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: room_assets; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.room_assets (
    id integer NOT NULL,
    room_id integer NOT NULL,
    item_id integer NOT NULL,
    asset_id character varying NOT NULL,
    qr_code character varying,
    serial_number character varying,
    status character varying,
    purchase_date date,
    purchase_price double precision,
    last_inspection_date date,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.room_assets OWNER TO orchid_user;

--
-- Name: room_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.room_assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_assets_id_seq OWNER TO orchid_user;

--
-- Name: room_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.room_assets_id_seq OWNED BY public.room_assets.id;


--
-- Name: room_consumable_assignments; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.room_consumable_assignments (
    id integer NOT NULL,
    room_id integer NOT NULL,
    booking_id integer,
    assigned_at timestamp without time zone,
    assigned_by integer NOT NULL,
    notes text
);


ALTER TABLE public.room_consumable_assignments OWNER TO orchid_user;

--
-- Name: room_consumable_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.room_consumable_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_consumable_assignments_id_seq OWNER TO orchid_user;

--
-- Name: room_consumable_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.room_consumable_assignments_id_seq OWNED BY public.room_consumable_assignments.id;


--
-- Name: room_consumable_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.room_consumable_items (
    id integer NOT NULL,
    assignment_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity_assigned double precision NOT NULL,
    uom character varying NOT NULL
);


ALTER TABLE public.room_consumable_items OWNER TO orchid_user;

--
-- Name: room_consumable_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.room_consumable_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_consumable_items_id_seq OWNER TO orchid_user;

--
-- Name: room_consumable_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.room_consumable_items_id_seq OWNED BY public.room_consumable_items.id;


--
-- Name: room_inventory_audits; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.room_inventory_audits (
    id integer NOT NULL,
    room_id integer NOT NULL,
    room_inventory_item_id integer NOT NULL,
    expected_quantity double precision NOT NULL,
    found_quantity double precision NOT NULL,
    consumed_quantity double precision,
    billed_amount double precision,
    audit_date timestamp without time zone,
    audited_by integer NOT NULL,
    notes text
);


ALTER TABLE public.room_inventory_audits OWNER TO orchid_user;

--
-- Name: room_inventory_audits_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.room_inventory_audits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_inventory_audits_id_seq OWNER TO orchid_user;

--
-- Name: room_inventory_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.room_inventory_audits_id_seq OWNED BY public.room_inventory_audits.id;


--
-- Name: room_inventory_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.room_inventory_items (
    id integer NOT NULL,
    room_id integer NOT NULL,
    item_id integer NOT NULL,
    par_stock double precision,
    current_stock double precision,
    last_audit_date timestamp without time zone,
    last_audited_by integer,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.room_inventory_items OWNER TO orchid_user;

--
-- Name: room_inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.room_inventory_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_inventory_items_id_seq OWNER TO orchid_user;

--
-- Name: room_inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.room_inventory_items_id_seq OWNED BY public.room_inventory_items.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.rooms (
    id integer NOT NULL,
    number character varying NOT NULL,
    type character varying,
    price double precision,
    status character varying,
    image_url character varying,
    adults integer,
    children integer,
    air_conditioning boolean,
    wifi boolean,
    bathroom boolean,
    living_area boolean,
    terrace boolean,
    parking boolean,
    kitchen boolean,
    family_room boolean,
    bbq boolean,
    garden boolean,
    dining boolean,
    breakfast boolean,
    inventory_location_id integer,
    housekeeping_updated_at timestamp without time zone,
    last_maintenance_date date,
    housekeeping_status character varying DEFAULT 'Clean'::character varying,
    extra_images text
);


ALTER TABLE public.rooms OWNER TO orchid_user;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rooms_id_seq OWNER TO orchid_user;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: salary_payments; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.salary_payments (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    month character varying NOT NULL,
    year integer NOT NULL,
    month_number integer NOT NULL,
    basic_salary double precision NOT NULL,
    allowances double precision DEFAULT 0.0,
    deductions double precision DEFAULT 0.0,
    net_salary double precision NOT NULL,
    payment_date date,
    payment_method character varying,
    payment_status character varying DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    notes character varying
);


ALTER TABLE public.salary_payments OWNER TO orchid_user;

--
-- Name: salary_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.salary_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.salary_payments_id_seq OWNER TO orchid_user;

--
-- Name: salary_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.salary_payments_id_seq OWNED BY public.salary_payments.id;


--
-- Name: security_equipment; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.security_equipment (
    id integer NOT NULL,
    equipment_type character varying NOT NULL,
    item_id integer,
    asset_id character varying NOT NULL,
    qr_code character varying,
    location_id integer NOT NULL,
    manufacturer character varying,
    model character varying,
    serial_number character varying,
    ip_address character varying,
    installation_date date,
    warranty_expiry date,
    amc_expiry date,
    status character varying,
    assigned_to integer,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.security_equipment OWNER TO orchid_user;

--
-- Name: security_equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.security_equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.security_equipment_id_seq OWNER TO orchid_user;

--
-- Name: security_equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.security_equipment_id_seq OWNED BY public.security_equipment.id;


--
-- Name: security_maintenance; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.security_maintenance (
    id integer NOT NULL,
    equipment_id integer NOT NULL,
    maintenance_type character varying NOT NULL,
    scheduled_date date,
    completed_date date,
    service_provider character varying,
    cost double precision,
    performed_by integer,
    description text,
    next_service_due date,
    notes text,
    created_at timestamp without time zone
);


ALTER TABLE public.security_maintenance OWNER TO orchid_user;

--
-- Name: security_maintenance_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.security_maintenance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.security_maintenance_id_seq OWNER TO orchid_user;

--
-- Name: security_maintenance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.security_maintenance_id_seq OWNED BY public.security_maintenance.id;


--
-- Name: security_uniforms; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.security_uniforms (
    id integer NOT NULL,
    item_id integer NOT NULL,
    employee_id integer NOT NULL,
    size character varying,
    quantity integer,
    issued_date date NOT NULL,
    return_date date,
    condition character varying,
    replacement_required boolean,
    notes text,
    created_at timestamp without time zone
);


ALTER TABLE public.security_uniforms OWNER TO orchid_user;

--
-- Name: security_uniforms_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.security_uniforms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.security_uniforms_id_seq OWNER TO orchid_user;

--
-- Name: security_uniforms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.security_uniforms_id_seq OWNED BY public.security_uniforms.id;


--
-- Name: service_images; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.service_images (
    id integer NOT NULL,
    service_id integer,
    image_url character varying NOT NULL
);


ALTER TABLE public.service_images OWNER TO orchid_user;

--
-- Name: service_images_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.service_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_images_id_seq OWNER TO orchid_user;

--
-- Name: service_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.service_images_id_seq OWNED BY public.service_images.id;


--
-- Name: service_inventory_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.service_inventory_items (
    service_id integer NOT NULL,
    inventory_item_id integer NOT NULL,
    quantity double precision NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.service_inventory_items OWNER TO orchid_user;

--
-- Name: service_requests; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.service_requests (
    id integer NOT NULL,
    food_order_id integer,
    room_id integer NOT NULL,
    employee_id integer,
    request_type character varying,
    description text,
    status character varying,
    created_at timestamp without time zone,
    completed_at timestamp without time zone,
    refill_data text,
    image_path character varying
);


ALTER TABLE public.service_requests OWNER TO orchid_user;

--
-- Name: service_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.service_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_requests_id_seq OWNER TO orchid_user;

--
-- Name: service_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.service_requests_id_seq OWNED BY public.service_requests.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.services (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    charges double precision NOT NULL,
    created_at timestamp without time zone,
    is_visible_to_guest boolean DEFAULT false NOT NULL,
    average_completion_time character varying,
    gst_rate double precision DEFAULT 0.18
);


ALTER TABLE public.services OWNER TO orchid_user;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.services_id_seq OWNER TO orchid_user;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: signature_experiences; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.signature_experiences (
    id integer NOT NULL,
    title character varying(255),
    description text,
    image_url character varying(255),
    is_active boolean
);


ALTER TABLE public.signature_experiences OWNER TO orchid_user;

--
-- Name: signature_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.signature_experiences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.signature_experiences_id_seq OWNER TO orchid_user;

--
-- Name: signature_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.signature_experiences_id_seq OWNED BY public.signature_experiences.id;


--
-- Name: stock_issue_details; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.stock_issue_details (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    item_id integer NOT NULL,
    issued_quantity double precision NOT NULL,
    unit character varying NOT NULL,
    unit_price double precision,
    notes text,
    batch_lot_number character varying,
    cost double precision,
    is_payable boolean DEFAULT false,
    is_paid boolean DEFAULT false,
    rental_price double precision,
    is_damaged boolean DEFAULT false,
    damage_notes text
);


ALTER TABLE public.stock_issue_details OWNER TO orchid_user;

--
-- Name: stock_issue_details_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.stock_issue_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_issue_details_id_seq OWNER TO orchid_user;

--
-- Name: stock_issue_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.stock_issue_details_id_seq OWNED BY public.stock_issue_details.id;


--
-- Name: stock_issues; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.stock_issues (
    id integer NOT NULL,
    issue_number character varying NOT NULL,
    requisition_id integer,
    issued_by integer NOT NULL,
    issue_date timestamp without time zone NOT NULL,
    notes text,
    created_at timestamp without time zone NOT NULL,
    source_location_id integer,
    destination_location_id integer
);


ALTER TABLE public.stock_issues OWNER TO orchid_user;

--
-- Name: stock_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.stock_issues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_issues_id_seq OWNER TO orchid_user;

--
-- Name: stock_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.stock_issues_id_seq OWNED BY public.stock_issues.id;


--
-- Name: stock_levels; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.stock_levels (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    quantity double precision,
    uom character varying NOT NULL,
    expiry_date date,
    batch_number character varying,
    last_updated timestamp without time zone
);


ALTER TABLE public.stock_levels OWNER TO orchid_user;

--
-- Name: stock_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.stock_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_levels_id_seq OWNER TO orchid_user;

--
-- Name: stock_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.stock_levels_id_seq OWNED BY public.stock_levels.id;


--
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.stock_movements (
    id integer NOT NULL,
    item_id integer NOT NULL,
    movement_type character varying NOT NULL,
    from_location_id integer,
    to_location_id integer NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    batch_number character varying,
    expiry_date date,
    movement_date timestamp without time zone,
    moved_by integer NOT NULL,
    reference_number character varying,
    notes text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.stock_movements OWNER TO orchid_user;

--
-- Name: stock_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.stock_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_movements_id_seq OWNER TO orchid_user;

--
-- Name: stock_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.stock_movements_id_seq OWNED BY public.stock_movements.id;


--
-- Name: stock_requisition_details; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.stock_requisition_details (
    id integer NOT NULL,
    requisition_id integer NOT NULL,
    item_id integer NOT NULL,
    requested_quantity double precision NOT NULL,
    unit character varying NOT NULL,
    notes text,
    approved_quantity double precision
);


ALTER TABLE public.stock_requisition_details OWNER TO orchid_user;

--
-- Name: stock_requisition_details_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.stock_requisition_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_requisition_details_id_seq OWNER TO orchid_user;

--
-- Name: stock_requisition_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.stock_requisition_details_id_seq OWNED BY public.stock_requisition_details.id;


--
-- Name: stock_requisitions; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.stock_requisitions (
    id integer NOT NULL,
    requisition_number character varying NOT NULL,
    destination_department character varying NOT NULL,
    requested_by integer NOT NULL,
    status character varying NOT NULL,
    notes text,
    approved_by integer,
    approved_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    date_needed date,
    priority character varying DEFAULT 'normal'::character varying
);


ALTER TABLE public.stock_requisitions OWNER TO orchid_user;

--
-- Name: stock_requisitions_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.stock_requisitions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_requisitions_id_seq OWNER TO orchid_user;

--
-- Name: stock_requisitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.stock_requisitions_id_seq OWNED BY public.stock_requisitions.id;


--
-- Name: stock_usage; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.stock_usage (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    usage_type character varying NOT NULL,
    recipe_id integer,
    food_order_id integer,
    usage_date timestamp without time zone,
    used_by integer NOT NULL,
    notes text
);


ALTER TABLE public.stock_usage OWNER TO orchid_user;

--
-- Name: stock_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.stock_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_usage_id_seq OWNER TO orchid_user;

--
-- Name: stock_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.stock_usage_id_seq OWNED BY public.stock_usage.id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    description character varying(255),
    updated_at timestamp with time zone
);


ALTER TABLE public.system_settings OWNER TO orchid_user;

--
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_settings_id_seq OWNER TO orchid_user;

--
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- Name: units_of_measurement; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.units_of_measurement (
    id integer NOT NULL,
    name character varying NOT NULL,
    symbol character varying,
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.units_of_measurement OWNER TO orchid_user;

--
-- Name: units_of_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.units_of_measurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.units_of_measurement_id_seq OWNER TO orchid_user;

--
-- Name: units_of_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.units_of_measurement_id_seq OWNED BY public.units_of_measurement.id;


--
-- Name: uom_conversions; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.uom_conversions (
    id integer NOT NULL,
    item_id integer NOT NULL,
    from_uom character varying NOT NULL,
    to_uom character varying NOT NULL,
    conversion_factor double precision NOT NULL
);


ALTER TABLE public.uom_conversions OWNER TO orchid_user;

--
-- Name: uom_conversions_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.uom_conversions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uom_conversions_id_seq OWNER TO orchid_user;

--
-- Name: uom_conversions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.uom_conversions_id_seq OWNED BY public.uom_conversions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying,
    email character varying,
    hashed_password character varying,
    phone character varying,
    is_active boolean,
    role_id integer
);


ALTER TABLE public.users OWNER TO orchid_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO orchid_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vendor_items; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.vendor_items (
    id integer NOT NULL,
    vendor_id integer NOT NULL,
    item_id integer NOT NULL,
    unit_price double precision NOT NULL,
    uom character varying NOT NULL,
    effective_from date NOT NULL,
    effective_to date,
    is_current boolean,
    notes text,
    created_at timestamp without time zone
);


ALTER TABLE public.vendor_items OWNER TO orchid_user;

--
-- Name: vendor_items_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.vendor_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendor_items_id_seq OWNER TO orchid_user;

--
-- Name: vendor_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.vendor_items_id_seq OWNED BY public.vendor_items.id;


--
-- Name: vendor_performance; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.vendor_performance (
    id integer NOT NULL,
    vendor_id integer NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    on_time_delivery_rate double precision,
    quality_score double precision,
    price_competitiveness double precision,
    total_orders integer,
    total_value double precision,
    notes text,
    created_at timestamp without time zone
);


ALTER TABLE public.vendor_performance OWNER TO orchid_user;

--
-- Name: vendor_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.vendor_performance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendor_performance_id_seq OWNER TO orchid_user;

--
-- Name: vendor_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.vendor_performance_id_seq OWNED BY public.vendor_performance.id;


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.vendors (
    id integer NOT NULL,
    name character varying NOT NULL,
    company_name character varying,
    gst_registration_type character varying,
    gst_number character varying,
    legal_name character varying,
    trade_name character varying,
    pan_number character varying,
    qmp_scheme boolean NOT NULL,
    msme_udyam_no character varying,
    contact_person character varying,
    email character varying,
    phone character varying,
    billing_address text,
    billing_state character varying,
    shipping_address text,
    distance_km double precision,
    address text,
    city character varying,
    state character varying,
    pincode character varying,
    country character varying,
    is_msme_registered boolean NOT NULL,
    tds_apply boolean NOT NULL,
    rcm_applicable boolean NOT NULL,
    payment_terms character varying,
    preferred_payment_method character varying,
    account_holder_name character varying,
    bank_name character varying,
    account_number character varying,
    ifsc_code character varying,
    branch_name character varying,
    upi_id character varying,
    upi_mobile_number character varying,
    notes text,
    is_active boolean NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.vendors OWNER TO orchid_user;

--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.vendors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendors_id_seq OWNER TO orchid_user;

--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.vendors_id_seq OWNED BY public.vendors.id;


--
-- Name: vouchers; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.vouchers (
    id integer NOT NULL,
    code character varying,
    discount_percent double precision,
    expiry_date timestamp without time zone
);


ALTER TABLE public.vouchers OWNER TO orchid_user;

--
-- Name: vouchers_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.vouchers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vouchers_id_seq OWNER TO orchid_user;

--
-- Name: vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.vouchers_id_seq OWNED BY public.vouchers.id;


--
-- Name: wastage_logs; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.wastage_logs (
    id integer NOT NULL,
    item_id integer NOT NULL,
    location_id integer NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    reason character varying NOT NULL,
    wastage_date timestamp without time zone,
    logged_by integer NOT NULL,
    notes text
);


ALTER TABLE public.wastage_logs OWNER TO orchid_user;

--
-- Name: wastage_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.wastage_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wastage_logs_id_seq OWNER TO orchid_user;

--
-- Name: wastage_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.wastage_logs_id_seq OWNED BY public.wastage_logs.id;


--
-- Name: waste_logs; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.waste_logs (
    id integer NOT NULL,
    item_id integer,
    batch_number character varying,
    expiry_date date,
    quantity double precision NOT NULL,
    unit character varying NOT NULL,
    reason_code character varying NOT NULL,
    photo_path character varying,
    notes text,
    reported_by integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    log_number character varying,
    location_id integer,
    action_taken character varying,
    waste_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    food_item_id integer,
    is_food_item boolean DEFAULT false NOT NULL
);


ALTER TABLE public.waste_logs OWNER TO orchid_user;

--
-- Name: waste_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.waste_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.waste_logs_id_seq OWNER TO orchid_user;

--
-- Name: waste_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.waste_logs_id_seq OWNED BY public.waste_logs.id;


--
-- Name: work_order_part_issues; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.work_order_part_issues (
    id integer NOT NULL,
    work_order_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity double precision NOT NULL,
    uom character varying NOT NULL,
    from_location_id integer NOT NULL,
    issued_by integer NOT NULL,
    issued_date timestamp without time zone,
    notes text
);


ALTER TABLE public.work_order_part_issues OWNER TO orchid_user;

--
-- Name: work_order_part_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.work_order_part_issues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.work_order_part_issues_id_seq OWNER TO orchid_user;

--
-- Name: work_order_part_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.work_order_part_issues_id_seq OWNED BY public.work_order_part_issues.id;


--
-- Name: work_order_parts; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.work_order_parts (
    id integer NOT NULL,
    work_order_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity_required double precision NOT NULL,
    quantity_issued double precision,
    uom character varying NOT NULL,
    notes text
);


ALTER TABLE public.work_order_parts OWNER TO orchid_user;

--
-- Name: work_order_parts_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.work_order_parts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.work_order_parts_id_seq OWNER TO orchid_user;

--
-- Name: work_order_parts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.work_order_parts_id_seq OWNED BY public.work_order_parts.id;


--
-- Name: work_orders; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.work_orders (
    id integer NOT NULL,
    wo_number character varying NOT NULL,
    asset_id integer,
    location_id integer,
    title character varying NOT NULL,
    description text,
    work_type character varying NOT NULL,
    priority character varying,
    status public.workorderstatus,
    reported_by integer NOT NULL,
    assigned_to integer,
    scheduled_date timestamp without time zone,
    started_date timestamp without time zone,
    completed_date timestamp without time zone,
    estimated_cost double precision,
    actual_cost double precision,
    service_provider character varying,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.work_orders OWNER TO orchid_user;

--
-- Name: work_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.work_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.work_orders_id_seq OWNER TO orchid_user;

--
-- Name: work_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.work_orders_id_seq OWNED BY public.work_orders.id;


--
-- Name: working_logs; Type: TABLE; Schema: public; Owner: orchid_user
--

CREATE TABLE public.working_logs (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    date date NOT NULL,
    check_in_time time without time zone,
    check_out_time time without time zone,
    location character varying
);


ALTER TABLE public.working_logs OWNER TO orchid_user;

--
-- Name: working_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: orchid_user
--

CREATE SEQUENCE public.working_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.working_logs_id_seq OWNER TO orchid_user;

--
-- Name: working_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: orchid_user
--

ALTER SEQUENCE public.working_logs_id_seq OWNED BY public.working_logs.id;


--
-- Name: account_groups id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.account_groups ALTER COLUMN id SET DEFAULT nextval('public.account_groups_id_seq'::regclass);


--
-- Name: account_ledgers id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.account_ledgers ALTER COLUMN id SET DEFAULT nextval('public.account_ledgers_id_seq'::regclass);


--
-- Name: activity_logs id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN id SET DEFAULT nextval('public.activity_logs_id_seq'::regclass);


--
-- Name: approval_matrices id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_matrices ALTER COLUMN id SET DEFAULT nextval('public.approval_matrices_id_seq'::regclass);


--
-- Name: approval_requests id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_requests ALTER COLUMN id SET DEFAULT nextval('public.approval_requests_id_seq'::regclass);


--
-- Name: asset_inspections id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_inspections ALTER COLUMN id SET DEFAULT nextval('public.asset_inspections_id_seq'::regclass);


--
-- Name: asset_maintenance id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_maintenance ALTER COLUMN id SET DEFAULT nextval('public.asset_maintenance_id_seq'::regclass);


--
-- Name: asset_mappings id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_mappings ALTER COLUMN id SET DEFAULT nextval('public.asset_mappings_id_seq'::regclass);


--
-- Name: asset_registry id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_registry ALTER COLUMN id SET DEFAULT nextval('public.asset_registry_id_seq'::regclass);


--
-- Name: assigned_services id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.assigned_services ALTER COLUMN id SET DEFAULT nextval('public.assigned_services_id_seq'::regclass);


--
-- Name: attendances id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);


--
-- Name: audit_discrepancies id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.audit_discrepancies ALTER COLUMN id SET DEFAULT nextval('public.audit_discrepancies_id_seq'::regclass);


--
-- Name: booking_rooms id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.booking_rooms ALTER COLUMN id SET DEFAULT nextval('public.booking_rooms_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: check_availability id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.check_availability ALTER COLUMN id SET DEFAULT nextval('public.check_availability_id_seq'::regclass);


--
-- Name: checklist_executions id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_executions ALTER COLUMN id SET DEFAULT nextval('public.checklist_executions_id_seq'::regclass);


--
-- Name: checklist_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_items ALTER COLUMN id SET DEFAULT nextval('public.checklist_items_id_seq'::regclass);


--
-- Name: checklist_responses id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_responses ALTER COLUMN id SET DEFAULT nextval('public.checklist_responses_id_seq'::regclass);


--
-- Name: checklists id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklists ALTER COLUMN id SET DEFAULT nextval('public.checklists_id_seq'::regclass);


--
-- Name: checkout_payments id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_payments ALTER COLUMN id SET DEFAULT nextval('public.checkout_payments_id_seq'::regclass);


--
-- Name: checkout_requests id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_requests ALTER COLUMN id SET DEFAULT nextval('public.checkout_requests_id_seq'::regclass);


--
-- Name: checkout_verifications id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_verifications ALTER COLUMN id SET DEFAULT nextval('public.checkout_verifications_id_seq'::regclass);


--
-- Name: checkouts id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkouts ALTER COLUMN id SET DEFAULT nextval('public.checkouts_id_seq'::regclass);


--
-- Name: consumable_usage id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.consumable_usage ALTER COLUMN id SET DEFAULT nextval('public.consumable_usage_id_seq'::regclass);


--
-- Name: cost_centers id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.cost_centers ALTER COLUMN id SET DEFAULT nextval('public.cost_centers_id_seq'::regclass);


--
-- Name: damage_reports id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.damage_reports ALTER COLUMN id SET DEFAULT nextval('public.damage_reports_id_seq'::regclass);


--
-- Name: employee_inventory_assignments id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employee_inventory_assignments ALTER COLUMN id SET DEFAULT nextval('public.employee_inventory_assignments_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: eod_audit_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.eod_audit_items ALTER COLUMN id SET DEFAULT nextval('public.eod_audit_items_id_seq'::regclass);


--
-- Name: eod_audits id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.eod_audits ALTER COLUMN id SET DEFAULT nextval('public.eod_audits_id_seq'::regclass);


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expenses ALTER COLUMN id SET DEFAULT nextval('public.expenses_id_seq'::regclass);


--
-- Name: expiry_alerts id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expiry_alerts ALTER COLUMN id SET DEFAULT nextval('public.expiry_alerts_id_seq'::regclass);


--
-- Name: fire_safety_equipment id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_equipment ALTER COLUMN id SET DEFAULT nextval('public.fire_safety_equipment_id_seq'::regclass);


--
-- Name: fire_safety_incidents id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_incidents ALTER COLUMN id SET DEFAULT nextval('public.fire_safety_incidents_id_seq'::regclass);


--
-- Name: fire_safety_inspections id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_inspections ALTER COLUMN id SET DEFAULT nextval('public.fire_safety_inspections_id_seq'::regclass);


--
-- Name: fire_safety_maintenance id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_maintenance ALTER COLUMN id SET DEFAULT nextval('public.fire_safety_maintenance_id_seq'::regclass);


--
-- Name: first_aid_kit_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kit_items ALTER COLUMN id SET DEFAULT nextval('public.first_aid_kit_items_id_seq'::regclass);


--
-- Name: first_aid_kits id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kits ALTER COLUMN id SET DEFAULT nextval('public.first_aid_kits_id_seq'::regclass);


--
-- Name: food_categories id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_categories ALTER COLUMN id SET DEFAULT nextval('public.food_categories_id_seq'::regclass);


--
-- Name: food_item_images id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_item_images ALTER COLUMN id SET DEFAULT nextval('public.food_item_images_id_seq'::regclass);


--
-- Name: food_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_items ALTER COLUMN id SET DEFAULT nextval('public.food_items_id_seq'::regclass);


--
-- Name: food_order_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_order_items ALTER COLUMN id SET DEFAULT nextval('public.food_order_items_id_seq'::regclass);


--
-- Name: food_orders id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_orders ALTER COLUMN id SET DEFAULT nextval('public.food_orders_id_seq'::regclass);


--
-- Name: gallery id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.gallery ALTER COLUMN id SET DEFAULT nextval('public.gallery_id_seq'::regclass);


--
-- Name: goods_received_notes id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.goods_received_notes ALTER COLUMN id SET DEFAULT nextval('public.goods_received_notes_id_seq'::regclass);


--
-- Name: grn_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.grn_items ALTER COLUMN id SET DEFAULT nextval('public.grn_items_id_seq'::regclass);


--
-- Name: guest_suggestions id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.guest_suggestions ALTER COLUMN id SET DEFAULT nextval('public.guest_suggestions_id_seq'::regclass);


--
-- Name: header_banner id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.header_banner ALTER COLUMN id SET DEFAULT nextval('public.header_banner_id_seq'::regclass);


--
-- Name: indent_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indent_items ALTER COLUMN id SET DEFAULT nextval('public.indent_items_id_seq'::regclass);


--
-- Name: indents id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indents ALTER COLUMN id SET DEFAULT nextval('public.indents_id_seq'::regclass);


--
-- Name: inventory_categories id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_categories ALTER COLUMN id SET DEFAULT nextval('public.inventory_categories_id_seq'::regclass);


--
-- Name: inventory_expenses id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_expenses ALTER COLUMN id SET DEFAULT nextval('public.inventory_expenses_id_seq'::regclass);


--
-- Name: inventory_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_items ALTER COLUMN id SET DEFAULT nextval('public.inventory_items_id_seq'::regclass);


--
-- Name: inventory_transactions id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_transactions ALTER COLUMN id SET DEFAULT nextval('public.inventory_transactions_id_seq'::regclass);


--
-- Name: journal_entries id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entries ALTER COLUMN id SET DEFAULT nextval('public.journal_entries_id_seq'::regclass);


--
-- Name: journal_entry_lines id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entry_lines ALTER COLUMN id SET DEFAULT nextval('public.journal_entry_lines_id_seq'::regclass);


--
-- Name: key_management id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_management ALTER COLUMN id SET DEFAULT nextval('public.key_management_id_seq'::regclass);


--
-- Name: key_movements id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_movements ALTER COLUMN id SET DEFAULT nextval('public.key_movements_id_seq'::regclass);


--
-- Name: laundry_logs id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.laundry_logs ALTER COLUMN id SET DEFAULT nextval('public.laundry_logs_id_seq'::regclass);


--
-- Name: laundry_services id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.laundry_services ALTER COLUMN id SET DEFAULT nextval('public.laundry_services_id_seq'::regclass);


--
-- Name: leaves id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.leaves ALTER COLUMN id SET DEFAULT nextval('public.leaves_id_seq'::regclass);


--
-- Name: legal_documents id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.legal_documents ALTER COLUMN id SET DEFAULT nextval('public.legal_documents_id_seq'::regclass);


--
-- Name: linen_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_items ALTER COLUMN id SET DEFAULT nextval('public.linen_items_id_seq'::regclass);


--
-- Name: linen_movements id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_movements ALTER COLUMN id SET DEFAULT nextval('public.linen_movements_id_seq'::regclass);


--
-- Name: linen_stocks id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_stocks ALTER COLUMN id SET DEFAULT nextval('public.linen_stocks_id_seq'::regclass);


--
-- Name: linen_wash_logs id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_wash_logs ALTER COLUMN id SET DEFAULT nextval('public.linen_wash_logs_id_seq'::regclass);


--
-- Name: location_stocks id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.location_stocks ALTER COLUMN id SET DEFAULT nextval('public.location_stocks_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: lost_found id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.lost_found ALTER COLUMN id SET DEFAULT nextval('public.lost_found_id_seq'::regclass);


--
-- Name: maintenance_tickets id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.maintenance_tickets ALTER COLUMN id SET DEFAULT nextval('public.maintenance_tickets_id_seq'::regclass);


--
-- Name: nearby_attraction_banners id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.nearby_attraction_banners ALTER COLUMN id SET DEFAULT nextval('public.nearby_attraction_banners_id_seq'::regclass);


--
-- Name: nearby_attractions id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.nearby_attractions ALTER COLUMN id SET DEFAULT nextval('public.nearby_attractions_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: office_inventory_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_inventory_items ALTER COLUMN id SET DEFAULT nextval('public.office_inventory_items_id_seq'::regclass);


--
-- Name: office_requisitions id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions ALTER COLUMN id SET DEFAULT nextval('public.office_requisitions_id_seq'::regclass);


--
-- Name: outlet_stocks id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlet_stocks ALTER COLUMN id SET DEFAULT nextval('public.outlet_stocks_id_seq'::regclass);


--
-- Name: outlets id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlets ALTER COLUMN id SET DEFAULT nextval('public.outlets_id_seq'::regclass);


--
-- Name: package_booking_rooms id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_booking_rooms ALTER COLUMN id SET DEFAULT nextval('public.package_booking_rooms_id_seq'::regclass);


--
-- Name: package_bookings id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_bookings ALTER COLUMN id SET DEFAULT nextval('public.package_bookings_id_seq'::regclass);


--
-- Name: package_images id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_images ALTER COLUMN id SET DEFAULT nextval('public.package_images_id_seq'::regclass);


--
-- Name: packages id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.packages ALTER COLUMN id SET DEFAULT nextval('public.packages_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: perishable_batches id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.perishable_batches ALTER COLUMN id SET DEFAULT nextval('public.perishable_batches_id_seq'::regclass);


--
-- Name: plan_weddings id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.plan_weddings ALTER COLUMN id SET DEFAULT nextval('public.plan_weddings_id_seq'::regclass);


--
-- Name: po_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.po_items ALTER COLUMN id SET DEFAULT nextval('public.po_items_id_seq'::regclass);


--
-- Name: purchase_details id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_details ALTER COLUMN id SET DEFAULT nextval('public.purchase_details_id_seq'::regclass);


--
-- Name: purchase_entries id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entries ALTER COLUMN id SET DEFAULT nextval('public.purchase_entries_id_seq'::regclass);


--
-- Name: purchase_entry_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entry_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_entry_items_id_seq'::regclass);


--
-- Name: purchase_masters id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_masters ALTER COLUMN id SET DEFAULT nextval('public.purchase_masters_id_seq'::regclass);


--
-- Name: purchase_orders id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN id SET DEFAULT nextval('public.purchase_orders_id_seq'::regclass);


--
-- Name: recipe_ingredients id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.recipe_ingredients ALTER COLUMN id SET DEFAULT nextval('public.recipe_ingredients_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: resort_info id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.resort_info ALTER COLUMN id SET DEFAULT nextval('public.resort_info_id_seq'::regclass);


--
-- Name: restock_alerts id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.restock_alerts ALTER COLUMN id SET DEFAULT nextval('public.restock_alerts_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: room_assets id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_assets ALTER COLUMN id SET DEFAULT nextval('public.room_assets_id_seq'::regclass);


--
-- Name: room_consumable_assignments id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_assignments ALTER COLUMN id SET DEFAULT nextval('public.room_consumable_assignments_id_seq'::regclass);


--
-- Name: room_consumable_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_items ALTER COLUMN id SET DEFAULT nextval('public.room_consumable_items_id_seq'::regclass);


--
-- Name: room_inventory_audits id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_audits ALTER COLUMN id SET DEFAULT nextval('public.room_inventory_audits_id_seq'::regclass);


--
-- Name: room_inventory_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_items ALTER COLUMN id SET DEFAULT nextval('public.room_inventory_items_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: salary_payments id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.salary_payments ALTER COLUMN id SET DEFAULT nextval('public.salary_payments_id_seq'::regclass);


--
-- Name: security_equipment id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_equipment ALTER COLUMN id SET DEFAULT nextval('public.security_equipment_id_seq'::regclass);


--
-- Name: security_maintenance id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_maintenance ALTER COLUMN id SET DEFAULT nextval('public.security_maintenance_id_seq'::regclass);


--
-- Name: security_uniforms id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_uniforms ALTER COLUMN id SET DEFAULT nextval('public.security_uniforms_id_seq'::regclass);


--
-- Name: service_images id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_images ALTER COLUMN id SET DEFAULT nextval('public.service_images_id_seq'::regclass);


--
-- Name: service_requests id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_requests ALTER COLUMN id SET DEFAULT nextval('public.service_requests_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: signature_experiences id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.signature_experiences ALTER COLUMN id SET DEFAULT nextval('public.signature_experiences_id_seq'::regclass);


--
-- Name: stock_issue_details id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issue_details ALTER COLUMN id SET DEFAULT nextval('public.stock_issue_details_id_seq'::regclass);


--
-- Name: stock_issues id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issues ALTER COLUMN id SET DEFAULT nextval('public.stock_issues_id_seq'::regclass);


--
-- Name: stock_levels id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_levels ALTER COLUMN id SET DEFAULT nextval('public.stock_levels_id_seq'::regclass);


--
-- Name: stock_movements id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_movements ALTER COLUMN id SET DEFAULT nextval('public.stock_movements_id_seq'::regclass);


--
-- Name: stock_requisition_details id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_requisition_details ALTER COLUMN id SET DEFAULT nextval('public.stock_requisition_details_id_seq'::regclass);


--
-- Name: stock_requisitions id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_requisitions ALTER COLUMN id SET DEFAULT nextval('public.stock_requisitions_id_seq'::regclass);


--
-- Name: stock_usage id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_usage ALTER COLUMN id SET DEFAULT nextval('public.stock_usage_id_seq'::regclass);


--
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- Name: units_of_measurement id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.units_of_measurement ALTER COLUMN id SET DEFAULT nextval('public.units_of_measurement_id_seq'::regclass);


--
-- Name: uom_conversions id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.uom_conversions ALTER COLUMN id SET DEFAULT nextval('public.uom_conversions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vendor_items id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendor_items ALTER COLUMN id SET DEFAULT nextval('public.vendor_items_id_seq'::regclass);


--
-- Name: vendor_performance id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendor_performance ALTER COLUMN id SET DEFAULT nextval('public.vendor_performance_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendors ALTER COLUMN id SET DEFAULT nextval('public.vendors_id_seq'::regclass);


--
-- Name: vouchers id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vouchers ALTER COLUMN id SET DEFAULT nextval('public.vouchers_id_seq'::regclass);


--
-- Name: wastage_logs id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.wastage_logs ALTER COLUMN id SET DEFAULT nextval('public.wastage_logs_id_seq'::regclass);


--
-- Name: waste_logs id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.waste_logs ALTER COLUMN id SET DEFAULT nextval('public.waste_logs_id_seq'::regclass);


--
-- Name: work_order_part_issues id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_part_issues ALTER COLUMN id SET DEFAULT nextval('public.work_order_part_issues_id_seq'::regclass);


--
-- Name: work_order_parts id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_parts ALTER COLUMN id SET DEFAULT nextval('public.work_order_parts_id_seq'::regclass);


--
-- Name: work_orders id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_orders ALTER COLUMN id SET DEFAULT nextval('public.work_orders_id_seq'::regclass);


--
-- Name: working_logs id; Type: DEFAULT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.working_logs ALTER COLUMN id SET DEFAULT nextval('public.working_logs_id_seq'::regclass);


--
-- Data for Name: account_groups; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.account_groups (id, name, account_type, description, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: account_ledgers; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.account_ledgers (id, name, code, group_id, module, description, opening_balance, balance_type, is_active, tax_type, tax_rate, bank_name, account_number, ifsc_code, branch_name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.activity_logs (id, action, method, path, status_code, client_ip, user_id, details, "timestamp") FROM stdin;
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.alembic_version (version_num) FROM stdin;
a1a1bf16ff4a
\.


--
-- Data for Name: approval_matrices; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.approval_matrices (id, department_id, approval_type, min_amount, max_amount, level_1_approver_role, level_2_approver_role, level_3_approver_role, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: approval_requests; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.approval_requests (id, request_type, reference_id, reference_type, requested_by, amount, current_level, status, level_1_approver, level_1_status, level_1_date, level_2_approver, level_2_status, level_2_date, level_3_approver, level_3_status, level_3_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: asset_inspections; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.asset_inspections (id, asset_id, inspection_date, inspected_by, status, damage_description, charge_to_guest, charge_amount, notes) FROM stdin;
\.


--
-- Data for Name: asset_maintenance; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.asset_maintenance (id, asset_id, maintenance_type, scheduled_date, completed_date, service_provider, cost, performed_by, notes, next_service_due, created_at) FROM stdin;
\.


--
-- Data for Name: asset_mappings; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.asset_mappings (id, item_id, location_id, serial_number, assigned_date, assigned_by, notes, is_active, unassigned_date, quantity) FROM stdin;
7	22	13	12345	2026-02-11 18:13:12.182145	1	\N	t	\N	1
8	12	13	23234	2026-02-11 18:13:12.545436	1	\N	t	\N	1
9	22	17	838390	2026-02-11 18:46:13.754266	1	\N	t	\N	1
10	12	17	838838	2026-02-11 18:46:14.072308	1	\N	t	\N	1
\.


--
-- Data for Name: asset_registry; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.asset_registry (id, asset_tag_id, item_id, serial_number, current_location_id, status, purchase_date, warranty_expiry, last_maintenance_date, next_maintenance_due, purchase_master_id, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: assigned_services; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.assigned_services (id, service_id, employee_id, room_id, assigned_at, status, billing_status, last_used_at, override_charges) FROM stdin;
15	5	5	9	2026-02-11 18:34:06.069821	completed	billed	2026-02-11 18:51:54.215295	\N
16	4	5	9	2026-02-11 18:39:38.921768	completed	billed	2026-02-11 18:51:54.215295	\N
17	4	5	9	2026-02-11 18:41:23.571757	completed	billed	2026-02-11 18:52:48.628663	\N
\.


--
-- Data for Name: attendances; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.attendances (id, employee_id, date, status) FROM stdin;
\.


--
-- Data for Name: audit_discrepancies; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.audit_discrepancies (id, audit_id, item_id, location_id, system_quantity, physical_quantity, discrepancy, uom, resolved_by, resolved_at, notes, created_at) FROM stdin;
\.


--
-- Data for Name: booking_rooms; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.booking_rooms (id, booking_id, room_id) FROM stdin;
14	14	7
15	15	7
16	16	9
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.bookings (id, status, guest_name, guest_mobile, guest_email, check_in, check_out, adults, children, id_card_image_url, guest_photo_url, user_id, total_amount, advance_deposit, checked_in_at, is_id_verified, package_preferences, digital_signature_url, source, package_name, special_requests, preferences) FROM stdin;
14	checked_out	dfghjk	1234567890	asdf@gmail.com	2026-02-11	2026-02-12	1	0	id_14_10733531c96a4e55b5ae8c1088e1c77d.jpg	guest_14_d1a1ad077dda4690b989a565c7b02cae.jpg	1	2000	0	2026-02-11 11:54:27.561978	f	\N	\N	Direct	\N	\N	\N
15	checked_out	daion	9961239861	dayon10mathew@gmail.com	2026-02-11	2026-02-12	1	0	id_15_23c24ca111044eef8e29a139383c1b82.jpg	guest_15_5e8dae05d5a74dae8b076d80503c1189.jpg	1	2000	0	2026-02-11 14:30:20.162005	f	\N	\N	Direct	\N	\N	\N
16	checked_out	mathew	81812882	mathew@gmail.com	2026-02-12	2026-02-13	1	0	id_16_ba495b7177c84b189980a1d93889ffab.jpg	guest_16_3bc3c4ebcf2145ad9297ac3c4158f115.jpg	1	10000	0	2026-02-11 19:18:15.720134	f	\N	\N	Direct	\N	\N	\N
\.


--
-- Data for Name: check_availability; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.check_availability (id, name, email, phone, check_in, check_out, guests, is_active) FROM stdin;
\.


--
-- Data for Name: checklist_executions; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.checklist_executions (id, checklist_id, room_id, location_id, executed_by, executed_at, status, completed_at, notes) FROM stdin;
\.


--
-- Data for Name: checklist_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.checklist_items (id, checklist_id, item_text, item_type, is_required, order_index) FROM stdin;
\.


--
-- Data for Name: checklist_responses; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.checklist_responses (id, execution_id, item_id, response, status, notes, responded_by, responded_at) FROM stdin;
\.


--
-- Data for Name: checklists; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.checklists (id, name, category, module_type, description, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: checkout_payments; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.checkout_payments (id, checkout_id, payment_method, amount, transaction_id, notes, created_at) FROM stdin;
23	23	Card	2240	\N	Single payment method	2026-02-11 11:55:35.469732+00
24	24	Card	14160	\N	Single payment method	2026-02-11 12:29:27.133679+00
25	25	Card	28109.3	\N	Single payment method	2026-02-11 18:51:54.13858+00
26	26	Card	2240	\N	Single payment method	2026-02-11 19:07:37.974274+00
27	27	Card	12289.3	\N	Single payment method	2026-02-11 19:25:21.910108+00
\.


--
-- Data for Name: checkout_requests; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.checkout_requests (id, booking_id, package_booking_id, room_number, guest_name, status, requested_by, requested_at, inventory_checked, inventory_checked_by, inventory_checked_at, inventory_notes, checkout_id, created_at, updated_at, employee_id, completed_at, inventory_data) FROM stdin;
12	14	\N	001	dfghjk	completed	harry	2026-02-11 11:54:55.408964+00	t	harry	2026-02-11 11:55:19.924499		\N	2026-02-11 11:54:55.408964+00	2026-02-11 11:55:19.90955+00	5	2026-02-11 11:55:19.92613	[]
13	\N	2	001	Basil Abraham	completed	harry	2026-02-11 12:28:00.706717+00	t	harry	2026-02-11 12:28:41.855637		\N	2026-02-11 12:28:00.706717+00	2026-02-11 12:28:41.79434+00	5	2026-02-11 12:28:41.857985	[]
14	\N	3	103	alphi	completed	harry	2026-02-11 18:42:34.493803+00	t	harry	2026-02-11 18:47:10.696613		\N	2026-02-11 18:42:34.493803+00	2026-02-11 18:47:10.692989+00	5	2026-02-11 18:47:10.753345	[{"item_id": 19, "item_name": "Mineral water", "item_code": "434534", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 5.0, "is_rentable": false, "is_fixed_asset": false, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 0.0, "unit": "pcs", "complimentary_limit": 0.0}, {"item_id": 18, "item_name": "coca cola", "item_code": "3432434", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 3.0, "is_rentable": false, "is_fixed_asset": false, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 0.0, "unit": "pcs", "complimentary_limit": 0.0}, {"item_id": 24, "item_name": "Automation_Item_1770463715", "item_code": "SKU_1770463715", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": true, "is_fixed_asset": false, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 0.0, "unit": "kg", "complimentary_limit": 0.0}, {"item_id": 25, "item_name": "Req_Auto_Item_1770820951", "item_code": "", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": true, "is_fixed_asset": false, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 0.0, "unit": "kg", "complimentary_limit": 0.0}, {"item_id": 22, "item_name": "LED Bulb", "item_code": "654645", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": false, "is_fixed_asset": true, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 1.0, "unit": "pcs", "complimentary_limit": 0.0}, {"item_id": 12, "item_name": "Tv", "item_code": "00999", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": false, "is_fixed_asset": true, "return_location_id": null, "damage_location_id": null, "request_replacement": true, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 1.0, "unit": "pcs", "complimentary_limit": 0.0}, {"asset_registry_id": null, "item_id": 12, "item_name": "Tv", "replacement_cost": 5000.0, "notes": "", "return_location_id": null, "damage_location_id": null, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "request_replacement": true, "is_damaged": true, "is_returned": false, "missing_item_charge": 5000.0, "unit_price": 5000.0, "missing_qty": 1, "is_fixed_asset": true}]
15	15	\N	001	daion	completed	harry	2026-02-11 19:03:17.035889+00	t	harry	2026-02-11 19:07:03.737451		\N	2026-02-11 19:03:17.035889+00	2026-02-11 19:07:03.732149+00	5	2026-02-11 19:07:03.76999	[{"item_id": 22, "item_name": "LED Bulb", "item_code": "654645", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": false, "is_fixed_asset": true, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 1.0, "unit": "pcs", "complimentary_limit": 1.0}, {"item_id": 12, "item_name": "Tv", "item_code": "00999", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": false, "is_fixed_asset": true, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 1.0, "unit": "pcs", "complimentary_limit": 1.0}]
16	16	\N	103	mathew	completed	harry	2026-02-11 19:24:03.596363+00	t	harry	2026-02-11 19:24:52.559445		\N	2026-02-11 19:24:03.596363+00	2026-02-11 19:24:52.555921+00	5	2026-02-11 19:24:52.618891	[{"item_id": 19, "item_name": "Mineral water", "item_code": "434534", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 5.0, "is_rentable": false, "is_fixed_asset": false, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 0.0, "unit": "pcs", "complimentary_limit": 0.0}, {"item_id": 18, "item_name": "coca cola", "item_code": "3432434", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 3.0, "is_rentable": false, "is_fixed_asset": false, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 0.0, "unit": "pcs", "complimentary_limit": 0.0}, {"item_id": 24, "item_name": "Automation_Item_1770463715", "item_code": "SKU_1770463715", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": true, "is_fixed_asset": false, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 0.0, "unit": "kg", "complimentary_limit": 0.0}, {"item_id": 25, "item_name": "Req_Auto_Item_1770820951", "item_code": "", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": true, "is_fixed_asset": false, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 0.0, "unit": "kg", "complimentary_limit": 0.0}, {"item_id": 22, "item_name": "LED Bulb", "item_code": "654645", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 1.0, "is_rentable": false, "is_fixed_asset": true, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 1.0, "unit": "pcs", "complimentary_limit": 0.0}, {"item_id": 12, "item_name": "Tv", "item_code": "00999", "used_qty": 0.0, "missing_qty": 0.0, "damage_qty": 0.0, "allocated_stock": 0.0, "is_rentable": false, "is_fixed_asset": true, "return_location_id": null, "damage_location_id": null, "request_replacement": false, "is_laundry": false, "laundry_location_id": null, "is_waste": false, "waste_location_id": null, "mapped_asset_qty": 1.0, "unit": "pcs", "complimentary_limit": 0.0}]
\.


--
-- Data for Name: checkout_verifications; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.checkout_verifications (id, checkout_id, room_number, housekeeping_status, housekeeping_notes, housekeeping_approved_by, housekeeping_approved_at, consumables_audit_data, consumables_total_charge, asset_damages, asset_damage_total, key_card_returned, key_card_fee, created_at, checkout_request_id) FROM stdin;
23	25	103	pending	\N	\N	\N	{"19": {"actual": 0.0, "issued": 5.0, "limit": 0, "charge": 0.0, "is_rentable": false, "missing": 0.0}, "18": {"actual": 0.0, "issued": 3.0, "limit": 0, "charge": 0.0, "is_rentable": false, "missing": 0.0}, "24": {"actual": 0.0, "issued": 1.0, "limit": 0, "charge": 0.0, "is_rentable": true, "missing": 0.0}, "25": {"actual": 0.0, "issued": 1.0, "limit": 0, "charge": 0.0, "is_rentable": true, "missing": 0.0}}	0	[{"item_name": "Tv", "replacement_cost": 5000.0, "notes": ""}]	5000	t	0	2026-02-11 18:51:54.13858+00	\N
24	26	001	pending	\N	\N	\N	{}	0	[]	0	t	0	2026-02-11 19:07:37.974274+00	\N
25	27	103	pending	\N	\N	\N	{"19": {"actual": 0.0, "issued": 5.0, "limit": 0, "charge": 0.0, "is_rentable": false, "missing": 0.0}, "18": {"actual": 0.0, "issued": 3.0, "limit": 0, "charge": 0.0, "is_rentable": false, "missing": 0.0}, "24": {"actual": 0.0, "issued": 1.0, "limit": 0, "charge": 0.0, "is_rentable": true, "missing": 0.0}, "25": {"actual": 0.0, "issued": 1.0, "limit": 0, "charge": 0.0, "is_rentable": true, "missing": 0.0}}	0	[]	0	t	0	2026-02-11 19:25:21.910108+00	\N
\.


--
-- Data for Name: checkouts; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.checkouts (id, room_total, food_total, service_total, package_total, tax_amount, discount_amount, grand_total, guest_name, room_number, created_at, checkout_date, payment_method, booking_id, package_booking_id, payment_status, late_checkout_fee, consumables_charges, asset_damage_charges, key_card_fee, advance_deposit, tips_gratuity, guest_gstin, is_b2b, invoice_number, invoice_pdf_path, gate_pass_path, feedback_sent, bill_details, inventory_charges, notes) FROM stdin;
23	2000	0	0	0	240	0	2240	dfghjk	001	2026-02-11 11:55:35.469732+00	2026-02-12 00:00:00	Card	14	\N	Paid	0	0	0	0	0	0	\N	f	INV-2026-000001	\N	\N	f	{"generated_at": "2026-02-11T11:55:35.527141", "charges_breakdown": {"room_charges": 2000.0, "food_charges": 0.0, "service_charges": 0.0, "package_charges": 0.0, "consumables_charges": 0.0, "inventory_charges": 0.0, "asset_damage_charges": 0.0, "key_card_fee": 0.0, "late_checkout_fee": 0.0, "advance_deposit": 0.0, "tips_gratuity": 0.0, "room_gst": 240.0, "food_gst": 0.0, "service_gst": 0.0, "package_gst": 0.0, "consumables_gst": 0.0, "inventory_gst": 0.0, "asset_damage_gst": 0.0, "total_gst": 240.0, "food_items": [], "service_items": [], "consumables_items": [], "asset_damages": [], "inventory_usage": [], "fixed_assets": [], "total_due": 2000.0}, "consumables_audit": {"charges": 0.0, "gst": 0.0, "items": []}, "asset_damages": {"charges": 0.0, "gst": 0.0, "items": []}, "inventory_usage": [], "fixed_assets": []}	0	\N
24	0	0	0	12000	2160	0	14160	Basil Abraham	001	2026-02-11 12:29:27.133679+00	2026-02-12 00:00:00	Card	\N	2	Paid	0	0	0	0	0	0	\N	f	INV-2026-000002	\N	\N	f	{"generated_at": "2026-02-11T12:29:27.190022", "charges_breakdown": {"room_charges": 0.0, "food_charges": 0.0, "service_charges": 0.0, "package_charges": 12000.0, "consumables_charges": 0.0, "inventory_charges": 0.0, "asset_damage_charges": 0.0, "key_card_fee": 0.0, "late_checkout_fee": 0.0, "advance_deposit": 0.0, "tips_gratuity": 0.0, "room_gst": 0.0, "food_gst": 0.0, "service_gst": 0.0, "package_gst": 2160.0, "consumables_gst": 0.0, "inventory_gst": 0.0, "asset_damage_gst": 0.0, "total_gst": 2160.0, "food_items": [{"item_name": "biriyani", "quantity": 1, "amount": 0.0, "is_paid": false, "payment_status": "Complimentary"}, {"item_name": "biriyani", "quantity": 1, "amount": 0.0, "is_paid": false, "payment_status": "Complimentary"}], "service_items": [], "consumables_items": [], "asset_damages": [], "inventory_usage": [], "fixed_assets": [], "total_due": 12000.0}, "consumables_audit": {"charges": 0.0, "gst": 0.0, "items": []}, "asset_damages": {"charges": 0.0, "gst": 0.0, "items": []}, "inventory_usage": [], "fixed_assets": []}	0	\N
25	0	200	7000	12000	2543.3	0	28109.3	alphi	103	2026-02-11 18:51:54.13858+00	2026-02-12 00:00:00	Card	\N	3	Paid	0	0	0	0	0	0	\N	f	INV-2026-000003	\N	\N	f	{"generated_at": "2026-02-11T18:51:54.193987", "charges_breakdown": {"room_charges": 0.0, "food_charges": 200.0, "service_charges": 7000.0, "package_charges": 12000.0, "consumables_charges": 233.0, "inventory_charges": 233.0, "asset_damage_charges": 5900.0, "key_card_fee": 0.0, "late_checkout_fee": 0.0, "advance_deposit": 0.0, "tips_gratuity": 0.0, "room_gst": 0.0, "food_gst": 10.0, "service_gst": 350.0, "package_gst": 2160.0, "consumables_gst": 11.65, "inventory_gst": 11.65, "asset_damage_gst": 0.0, "total_gst": 2543.3, "food_items": [{"item_name": "doas", "quantity": 1, "amount": 0.0, "is_paid": false, "payment_status": "Complimentary"}, {"item_name": "biriyani", "quantity": 1, "amount": 0.0, "is_paid": false, "payment_status": "Complimentary"}, {"item_name": "doas", "quantity": 1, "amount": 100, "is_paid": false, "payment_status": "Unpaid"}, {"item_name": "doas", "quantity": 1, "amount": 100, "is_paid": false, "payment_status": "Unpaid"}], "service_items": [{"service_name": "DEluxe and Ac", "charges": 3000.0, "is_paid": false, "payment_status": "Unpaid"}, {"service_name": "spa", "charges": 2000.0, "is_paid": false, "payment_status": "Unpaid"}, {"service_name": "spa", "charges": 2000.0, "is_paid": false, "payment_status": "Unpaid"}], "consumables_items": [{"date": "2026-02-11T18:47:10.753345", "item_id": 24, "item_name": "Automation_Item_1770463715", "actual_consumed": 0.0, "complimentary_limit": 0.0, "charge_per_unit": 147.0, "total_charge": 153.0}, {"date": "2026-02-11T18:47:10.753345", "item_id": 25, "item_name": "Req_Auto_Item_1770820951", "actual_consumed": 0.0, "complimentary_limit": 0.0, "charge_per_unit": 52.5, "total_charge": 80.0}], "asset_damages": [{"item_name": "Tv (Missing)", "replacement_cost": 5900.0, "notes": "Damaged: 0.0, Missing: 1.0"}], "inventory_usage": [{"date": "2026-02-11T18:47:10.753345", "item_name": "Automation_Item_1770463715", "category": "Grocery", "quantity": 1.0, "unit": "kg", "rental_price": 153.0, "rental_charge": 153.0, "is_rental": true, "is_payable": true, "notes": "Rental"}, {"date": "2026-02-11T18:47:10.753345", "item_name": "Req_Auto_Item_1770820951", "category": "Grocery", "quantity": 1.0, "unit": "kg", "rental_price": 80.0, "rental_charge": 80.0, "is_rental": true, "is_payable": true, "notes": "Rental"}], "fixed_assets": [{"item_name": "Tv", "status": "Missing", "quantity": 1.0, "notes": "Verified from audit"}], "total_due": 25566.0}, "consumables_audit": {"charges": 0.0, "gst": 0.0, "items": [{"date": "2026-02-11T18:47:10.753345", "item_id": 24, "item_name": "Automation_Item_1770463715", "actual_consumed": 0.0, "complimentary_limit": 0.0, "charge_per_unit": 147.0, "total_charge": 153.0}, {"date": "2026-02-11T18:47:10.753345", "item_id": 25, "item_name": "Req_Auto_Item_1770820951", "actual_consumed": 0.0, "complimentary_limit": 0.0, "charge_per_unit": 52.5, "total_charge": 80.0}]}, "asset_damages": {"charges": 0.0, "gst": 0.0, "items": [{"item_name": "Tv (Missing)", "replacement_cost": 5900.0, "notes": "Damaged: 0.0, Missing: 1.0"}]}, "inventory_usage": [{"date": "2026-02-11T18:47:10.753345", "item_name": "Automation_Item_1770463715", "category": "Grocery", "quantity": 1.0, "unit": "kg", "rental_price": 153.0, "rental_charge": 153.0, "is_rental": true, "is_payable": true, "notes": "Rental"}, {"date": "2026-02-11T18:47:10.753345", "item_name": "Req_Auto_Item_1770820951", "category": "Grocery", "quantity": 1.0, "unit": "kg", "rental_price": 80.0, "rental_charge": 80.0, "is_rental": true, "is_payable": true, "notes": "Rental"}], "fixed_assets": [{"item_name": "Tv", "status": "Missing", "quantity": 1.0, "notes": "Verified from audit"}]}	233	\N
26	2000	0	0	0	240	0	2240	daion	001	2026-02-11 19:07:37.974274+00	2026-02-12 00:00:00	Card	15	\N	Paid	0	0	0	0	0	0	\N	f	INV-2026-000004	\N	\N	f	{"generated_at": "2026-02-11T19:07:38.018229", "charges_breakdown": {"room_charges": 2000.0, "food_charges": 0.0, "service_charges": 0.0, "package_charges": 0.0, "consumables_charges": 0.0, "inventory_charges": 0.0, "asset_damage_charges": 0.0, "key_card_fee": 0.0, "late_checkout_fee": 0.0, "advance_deposit": 0.0, "tips_gratuity": 0.0, "room_gst": 240.0, "food_gst": 0.0, "service_gst": 0.0, "package_gst": 0.0, "consumables_gst": 0.0, "inventory_gst": 0.0, "asset_damage_gst": 0.0, "total_gst": 240.0, "food_items": [{"item_name": "biriyani", "quantity": 2, "amount": 0.0, "is_paid": true, "payment_status": "PAID (cash)", "payment_method": null, "payment_time": null, "gst_amount": null, "total_with_gst": null}, {"item_name": "biriyani", "quantity": 1, "amount": 0.0, "is_paid": true, "payment_status": "Previously Billed"}, {"item_name": "biriyani", "quantity": 1, "amount": 0.0, "is_paid": true, "payment_status": "Previously Billed"}], "service_items": [], "consumables_items": [], "asset_damages": [], "inventory_usage": [], "fixed_assets": [], "total_due": 2000.0}, "consumables_audit": {"charges": 0.0, "gst": 0.0, "items": []}, "asset_damages": {"charges": 0.0, "gst": 0.0, "items": []}, "inventory_usage": [], "fixed_assets": []}	0	\N
27	10000	0	0	0	1823.3000000000002	0	12289.3	mathew	103	2026-02-11 19:25:21.910108+00	2026-02-13 00:00:00	Card	16	\N	Paid	0	0	0	0	0	0	\N	f	INV-2026-000005	\N	\N	f	{"generated_at": "2026-02-11T19:25:22.027803", "charges_breakdown": {"room_charges": 10000.0, "food_charges": 0.0, "service_charges": 0.0, "package_charges": 0.0, "consumables_charges": 233.0, "inventory_charges": 233.0, "asset_damage_charges": 0.0, "key_card_fee": 0.0, "late_checkout_fee": 0.0, "advance_deposit": 0.0, "tips_gratuity": 0.0, "room_gst": 1800.0, "food_gst": 0.0, "service_gst": 0.0, "package_gst": 0.0, "consumables_gst": 11.65, "inventory_gst": 11.65, "asset_damage_gst": 0.0, "total_gst": 1823.3000000000002, "food_items": [], "service_items": [{"service_name": "DEluxe and Ac", "charges": 0.0, "is_paid": true, "payment_status": "Previously Billed"}, {"service_name": "spa", "charges": 0.0, "is_paid": true, "payment_status": "Previously Billed"}, {"service_name": "spa", "charges": 0.0, "is_paid": true, "payment_status": "Previously Billed"}], "consumables_items": [{"date": "2026-02-11T19:24:52.618891", "item_id": 24, "item_name": "Automation_Item_1770463715", "actual_consumed": 0.0, "complimentary_limit": 0.0, "charge_per_unit": 147.0, "total_charge": 153.0}, {"date": "2026-02-11T19:24:52.618891", "item_id": 25, "item_name": "Req_Auto_Item_1770820951", "actual_consumed": 0.0, "complimentary_limit": 0.0, "charge_per_unit": 52.5, "total_charge": 80.0}], "asset_damages": [], "inventory_usage": [{"date": "2026-02-11T19:24:52.618891", "item_name": "Automation_Item_1770463715", "category": "Grocery", "quantity": 1.0, "unit": "kg", "rental_price": 153.0, "rental_charge": 153.0, "is_rental": true, "is_payable": true, "notes": "Rental"}, {"date": "2026-02-11T19:24:52.618891", "item_name": "Req_Auto_Item_1770820951", "category": "Grocery", "quantity": 1.0, "unit": "kg", "rental_price": 80.0, "rental_charge": 80.0, "is_rental": true, "is_payable": true, "notes": "Rental"}], "fixed_assets": [], "total_due": 10466.0}, "consumables_audit": {"charges": 0.0, "gst": 0.0, "items": [{"date": "2026-02-11T19:24:52.618891", "item_id": 24, "item_name": "Automation_Item_1770463715", "actual_consumed": 0.0, "complimentary_limit": 0.0, "charge_per_unit": 147.0, "total_charge": 153.0}, {"date": "2026-02-11T19:24:52.618891", "item_id": 25, "item_name": "Req_Auto_Item_1770820951", "actual_consumed": 0.0, "complimentary_limit": 0.0, "charge_per_unit": 52.5, "total_charge": 80.0}]}, "asset_damages": {"charges": 0.0, "gst": 0.0, "items": []}, "inventory_usage": [{"date": "2026-02-11T19:24:52.618891", "item_name": "Automation_Item_1770463715", "category": "Grocery", "quantity": 1.0, "unit": "kg", "rental_price": 153.0, "rental_charge": 153.0, "is_rental": true, "is_payable": true, "notes": "Rental"}, {"date": "2026-02-11T19:24:52.618891", "item_name": "Req_Auto_Item_1770820951", "category": "Grocery", "quantity": 1.0, "unit": "kg", "rental_price": 80.0, "rental_charge": 80.0, "is_rental": true, "is_payable": true, "notes": "Rental"}], "fixed_assets": []}	233	\N
\.


--
-- Data for Name: consumable_usage; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.consumable_usage (id, room_id, booking_id, item_id, quantity_used, uom, usage_type, usage_date, recorded_by, charge_amount, notes) FROM stdin;
\.


--
-- Data for Name: cost_centers; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.cost_centers (id, name, code, description, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: damage_reports; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.damage_reports (id, item_id, location_id, room_id, damage_type, description, reported_by, reported_at, status, approved_by, approved_at, resolution_action, charge_to_guest, charge_amount, notes, resolved_at) FROM stdin;
\.


--
-- Data for Name: employee_inventory_assignments; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.employee_inventory_assignments (id, employee_id, assigned_service_id, item_id, quantity_assigned, quantity_used, quantity_returned, status, is_returned, assigned_at, returned_at, notes) FROM stdin;
41	5	17	13	0.5	0.5	0	completed	f	2026-02-11 18:41:23.608244	\N	Assigned from Main inventory  (LocID: 15)
42	5	17	19	1	1	0	completed	f	2026-02-11 18:41:23.618383	\N	Assigned from Main inventory  (LocID: 15)
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.employees (id, name, role, salary, join_date, image_url, user_id, paid_leave_balance, sick_leave_balance, long_leave_balance, wellness_leave_balance) FROM stdin;
5	harry	Manager	0	2026-01-20	\N	1	12	12	5	5
10	Maine	manager	60000	2026-02-04	uploads/Untitled.jpg	45	12	12	5	5
\.


--
-- Data for Name: eod_audit_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.eod_audit_items (id, audit_id, item_id, system_quantity, physical_quantity, variance, uom) FROM stdin;
\.


--
-- Data for Name: eod_audits; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.eod_audits (id, audit_date, location_id, audited_by, system_stock_value, physical_stock_value, variance, variance_percentage, notes, created_at) FROM stdin;
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.expenses (id, category, amount, date, description, employee_id, image, created_at, rcm_applicable, rcm_tax_rate, nature_of_supply, original_bill_no, self_invoice_number, vendor_id, rcm_liability_date, itc_eligible, department) FROM stdin;
\.


--
-- Data for Name: expiry_alerts; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.expiry_alerts (id, item_id, location_id, batch_number, expiry_date, days_until_expiry, status, created_at, acknowledged_at, acknowledged_by) FROM stdin;
\.


--
-- Data for Name: fire_safety_equipment; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.fire_safety_equipment (id, equipment_type, item_id, asset_id, qr_code, location_id, floor, zone, manufacturer, model, capacity, installation_date, expiry_date, last_inspection_date, next_inspection_date, last_service_date, next_service_date, status, certification_number, certification_expiry, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: fire_safety_incidents; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.fire_safety_incidents (id, equipment_id, incident_date, incident_type, location_id, reported_by, equipment_used, damage_assessment, action_taken, refill_required, investigation_report, notes) FROM stdin;
\.


--
-- Data for Name: fire_safety_inspections; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.fire_safety_inspections (id, equipment_id, inspection_date, inspected_by, inspection_type, status, pressure_check, visual_check, functional_check, notes, next_inspection_date) FROM stdin;
\.


--
-- Data for Name: fire_safety_maintenance; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.fire_safety_maintenance (id, equipment_id, service_type, service_date, service_provider, cost, performed_by, test_certificate_number, next_service_due, notes) FROM stdin;
\.


--
-- Data for Name: first_aid_kit_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.first_aid_kit_items (id, kit_id, item_id, par_quantity, current_quantity, expiry_date, last_restocked) FROM stdin;
\.


--
-- Data for Name: first_aid_kits; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.first_aid_kits (id, kit_number, location_id, last_checked_date, next_check_date, expiry_items_count, status, checked_by, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: food_categories; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.food_categories (id, name, image) FROM stdin;
2	Rice	category_d275fec4da4145688d0902ebd488a986_images (10).jfif
3	Desert	category_e228186f91774060a4b547cbbccaee3c_coffee.jpg
4	breakfast	category_9aef168920d04fe79c354e3fcf56bb3e_image.png
6	snack	category_f994e0caf1ec4b8aa487fdf75c969bee_Designer.png
\.


--
-- Data for Name: food_item_images; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.food_item_images (id, image_url, item_id) FROM stdin;
\.


--
-- Data for Name: food_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.food_items (id, name, description, price, available, category_id) FROM stdin;
4	biriyani	asdfghjk	100	true	2
5	doas	ghjaxzk	100	true	4
\.


--
-- Data for Name: food_order_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.food_order_items (id, order_id, food_item_id, quantity) FROM stdin;
4	4	4	1
5	5	4	1
6	6	5	1
7	7	4	1
8	8	5	1
9	8	5	1
10	9	4	5
11	10	4	2
\.


--
-- Data for Name: food_orders; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.food_orders (id, room_id, amount, assigned_employee_id, status, billing_status, created_at, order_type, delivery_request, payment_method, payment_time, gst_amount, total_with_gst, is_deleted, created_by_id, prepared_by_id) FROM stdin;
4	7	0	\N	completed	billed	2026-02-11 11:59:18.148776	room_service	SCHEDULED_FOR: 2026-02-12 20:27:00 -- Package Meal: Breakfast	\N	\N	\N	\N	f	\N	\N
5	7	0	\N	completed	billed	2026-02-11 11:59:18.166125	room_service	SCHEDULED_FOR: 2026-02-11 18:01:00 -- Package Meal: Snacks	\N	\N	\N	\N	f	\N	\N
6	9	0	\N	completed	unpaid	2026-02-11 15:43:15.803783	room_service	SCHEDULED_FOR: 2026-02-11 09:00:00 -- Package Meal: Breakfast	\N	\N	\N	\N	f	\N	\N
7	9	0	\N	completed	unpaid	2026-02-11 15:43:15.813569	room_service	SCHEDULED_FOR: 2026-02-11 23:00:00 -- Package Meal: Dinner	\N	\N	\N	\N	f	\N	\N
8	9	200	5	completed	unpaid	2026-02-11 18:36:56.566185	room_service	\N	\N	\N	\N	\N	f	5	\N
9	8	500	5	completed	paid	2026-02-11 18:56:47.522743	dine_in	\N	\N	\N	\N	\N	f	5	\N
10	7	200	5	completed	paid	2026-02-11 18:59:21.64618	room_service	\N	\N	\N	\N	\N	f	5	\N
\.


--
-- Data for Name: gallery; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.gallery (id, image_url, caption, is_active) FROM stdin;
\.


--
-- Data for Name: goods_received_notes; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.goods_received_notes (id, grn_number, po_id, received_by, verified_by, status, received_date, verified_date, notes) FROM stdin;
\.


--
-- Data for Name: grn_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.grn_items (id, grn_id, po_item_id, item_id, quantity, uom, expiry_date, batch_number, unit_price, location_id, barcode_generated) FROM stdin;
\.


--
-- Data for Name: guest_suggestions; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.guest_suggestions (id, guest_name, contact_info, suggestion, status, created_at) FROM stdin;
\.


--
-- Data for Name: header_banner; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.header_banner (id, title, subtitle, image_url, is_active) FROM stdin;
\.


--
-- Data for Name: indent_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.indent_items (id, indent_id, item_id, requested_quantity, approved_quantity, issued_quantity, uom, notes) FROM stdin;
\.


--
-- Data for Name: indents; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.indents (id, indent_number, requested_from_location_id, requested_to_location_id, status, requested_by, approved_by, requested_date, approved_date, fulfilled_date, notes) FROM stdin;
\.


--
-- Data for Name: inventory_categories; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.inventory_categories (id, name, description, is_active, created_at, updated_at, parent_department, gst_tax_rate, is_perishable, is_asset_fixed, is_sellable, track_laundry, allow_partial_usage, consumable_instant, classification, hsn_sac_code, default_gst_rate, cess_percentage, itc_eligibility, is_capital_good) FROM stdin;
8	Grocery		t	2026-02-03 18:40:25.363004	\N	Restaurant	5	t	f	f	f	t	t	Goods	09876	5	0	Eligible	f
7	Electronics		t	2026-02-03 18:39:23.119936	\N	Facility	18	f	t	f	f	f	f	Goods	0999	18	0	Eligible	t
9	NON alcoholic bev		t	2026-02-06 09:28:52.376644	\N	Restaurant	18	t	f	t	f	f	t	Goods	8787	18	0	Eligible	f
10	Linen		t	2026-02-06 09:36:55.109557	\N	Hotel	12	f	f	f	t	f	f	Goods	432453	12	0	Eligible	f
11	Automation_Cat_1770464604	Category created via automation	t	2026-02-07 11:43:30.666186	\N	Restaurant	18	f	f	f	f	f	f	Goods	996331	18	0	Eligible	t
\.


--
-- Data for Name: inventory_expenses; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.inventory_expenses (id, item_id, cost_center_id, quantity, uom, unit_cost, total_cost, issued_to, issued_by, issued_date, notes) FROM stdin;
\.


--
-- Data for Name: inventory_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.inventory_items (id, name, description, category_id, sku, barcode, base_uom_id, unit_price, selling_price, track_expiry, track_serial, track_batch, min_stock_level, max_stock_level, is_active, created_at, updated_at, hsn_code, gst_rate, item_code, sub_category, image_path, location, track_serial_number, is_sellable_to_guest, track_laundry_cycle, is_asset_fixed, maintenance_schedule_days, complimentary_limit, ingredient_yield_percentage, preferred_vendor_id, vendor_item_code, lead_time_days, is_perishable, unit, current_stock) FROM stdin;
17	coca cola		8	\N	\N	\N	20	40	\N	\N	\N	10	\N	f	2026-02-06 09:33:10.655837	2026-02-06 09:33:23.916502	hghgh	18	HHJHJ7654		\N	\N	f	t	f	f	\N	\N	\N	\N	\N	\N	t	pcs	0
14	bed sheet		9	\N	\N	\N	130	\N	\N	\N	\N	5	\N	f	2026-02-06 09:30:01.994687	2026-02-06 09:35:03.060368	gfdggg	12	4554455	Bedsheets	\N	\N	f	f	t	f	\N	\N	\N	\N	\N	\N	f	pcs	0
16	bath towel		9	\N	\N	\N	190	\N	\N	\N	\N	5	\N	f	2026-02-06 09:32:28.935784	2026-02-06 09:35:05.442548		12	FDDD75576	Towels	\N	\N	f	f	t	f	\N	\N	\N	\N	\N	\N	f	pcs	0
15	chicken		8	\N	\N	\N	180	\N	\N	\N	\N	9.98	\N	t	2026-02-06 09:30:49.600145	2026-02-11 19:06:22.93989	7656	0	54533		\N	\N	f	f	f	f	\N	\N	\N	\N	\N	\N	t	kg	19.1
18	coca cola		9	\N	\N	\N	20	40	\N	\N	\N	10	\N	t	2026-02-06 09:37:28.276498	2026-02-11 14:12:34.767514	342343	18	3432434		\N	\N	f	t	f	f	\N	\N	\N	\N	\N	\N	t	pcs	20
20	bed sheet		10	\N	\N	\N	100	\N	\N	\N	\N	5	\N	t	2026-02-06 09:39:01.069906	2026-02-11 14:12:34.768815	435435	12	45435	Bedsheets	\N	\N	f	f	t	f	\N	\N	\N	\N	\N	\N	f	pcs	20
21	bath towel		10	\N	\N	\N	50	\N	\N	\N	\N	5	\N	t	2026-02-06 09:39:31.657423	2026-02-11 14:12:34.768816	54656	0	35365	Towels	\N	\N	f	f	t	f	\N	\N	\N	\N	\N	\N	f	pcs	20
22	LED Bulb		7	\N	\N	\N	50	\N	\N	\N	\N	5	\N	t	2026-02-06 09:40:14.613378	2026-02-11 14:12:34.770323	43545	18	654645		\N	\N	t	f	f	f	\N	\N	\N	\N	\N	\N	f	pcs	20
23	Automation_Item_1770463109	Added via Playwright Automation	8	\N	\N	\N	100	150	\N	\N	\N	10	\N	f	2026-02-07 11:18:34.221197	2026-02-11 14:12:44.735182		5	SKU_1770463109		\N	\N	f	t	f	f	\N	\N	\N	\N	\N	\N	f	kg	0
25	Req_Auto_Item_1770820951		8	\N	\N	\N	50	80	\N	\N	\N	10	\N	t	2026-02-11 14:42:34.75096	2026-02-11 14:42:34.750966		5			\N	\N	f	t	f	f	\N	\N	\N	\N	\N	\N	f	kg	100
24	Automation_Item_1770463715	Added via Playwright Automation	8	\N	\N	\N	140	150	\N	\N	\N	10	\N	t	2026-02-07 11:28:40.71908	2026-02-11 18:30:30.040615	123456	5	SKU_1770463715		\N	\N	f	t	f	f	\N	\N	\N	\N	V-123	3	t	kg	10
19	Mineral water		9	\N	\N	\N	15	20	\N	\N	\N	10	\N	t	2026-02-06 09:38:06.12848	2026-02-11 18:41:23.605841	4545	18	434534		\N	\N	f	t	f	f	\N	\N	\N	\N	\N	\N	t	pcs	19
12	Tv		7	\N	\N	\N	5000	\N	\N	\N	\N	1	\N	t	2026-02-03 18:41:34.41327	2026-02-11 18:47:10.761648	090909	18	00999		\N	\N	t	f	f	f	\N	\N	\N	1	\N	\N	f	pcs	19
13	Milk		8	\N	\N	\N	45	50	\N	\N	\N	0	\N	t	2026-02-03 18:42:16.545493	2026-02-11 19:06:22.939887	09876	0	000		\N	\N	f	t	f	f	\N	\N	\N	1	\N	\N	t	liter	19.32
\.


--
-- Data for Name: inventory_transactions; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.inventory_transactions (id, item_id, transaction_type, quantity, unit_price, total_amount, reference_number, purchase_master_id, notes, created_by, created_at, department) FROM stdin;
181	13	in	20	45	900	PO-20260211-0001	24	Purchase received: PO-20260211-0001	1	2026-02-11 14:12:34.775773	\N
182	15	in	20	180	3600	PO-20260211-0001	24	Purchase received: PO-20260211-0001	1	2026-02-11 14:12:34.775778	\N
183	22	in	20	50	1000	PO-20260211-0001	24	Purchase received: PO-20260211-0001	1	2026-02-11 14:12:34.775781	\N
184	19	in	20	15	300	PO-20260211-0001	24	Purchase received: PO-20260211-0001	1	2026-02-11 14:12:34.775782	\N
185	18	in	20	20	400	PO-20260211-0001	24	Purchase received: PO-20260211-0001	1	2026-02-11 14:12:34.775784	\N
186	21	in	20	50	1000	PO-20260211-0001	24	Purchase received: PO-20260211-0001	1	2026-02-11 14:12:34.775786	\N
187	20	in	20	100	2000	PO-20260211-0001	24	Purchase received: PO-20260211-0001	1	2026-02-11 14:12:34.775788	\N
188	12	in	20	5000	100000	PO-20260211-0001	24	Purchase received: PO-20260211-0001	1	2026-02-11 14:12:34.77579	\N
189	25	adjustment	100	50	5000	\N	\N	Initial stock	1	2026-02-11 14:42:34.758271	\N
190	22	transfer_out	1	50	50	ISS-20260211-001	\N	Asset Assigned to Room 001	1	2026-02-11 18:13:12.196733	\N
191	22	transfer_in	1	50	50	ISS-20260211-001	\N	Asset Received from Central Warehouse	1	2026-02-11 18:13:12.196737	Room 001
192	12	transfer_out	1	5000	5000	ISS-20260211-002	\N	Asset Assigned to Room 001	1	2026-02-11 18:13:12.557352	\N
193	12	transfer_in	1	5000	5000	ISS-20260211-002	\N	Asset Received from Central Warehouse	1	2026-02-11 18:13:12.557357	Room 001
194	19	transfer_out	3	20	60	ISS-20260211-003	\N	Stock Issue: ISS-20260211-003 → Main Building - Room 103 - Extra allocation for booking BK-000003 (0 payable, 3 comp) - Source: 15	1	2026-02-11 18:25:10.029161	\N
195	19	transfer_in	3	20	60	ISS-20260211-003	\N	Stock Received: ISS-20260211-003 from 15	1	2026-02-11 18:25:10.029164	Main Building - Room 103
196	18	transfer_out	3	40	120	ISS-20260211-004	\N	Stock Issue: ISS-20260211-004 → Main Building - Room 103 - Extra allocation for booking BK-000003 (0 payable, 5 comp) - Source: 15	1	2026-02-11 18:25:57.281019	\N
197	18	transfer_in	3	40	120	ISS-20260211-004	\N	Stock Received: ISS-20260211-004 from 15	1	2026-02-11 18:25:57.281023	Main Building - Room 103
198	19	transfer_out	2	20	40	ISS-20260211-004	\N	Stock Issue: ISS-20260211-004 → Main Building - Room 103 - Extra allocation for booking BK-000003 (0 payable, 5 comp) - Source: 15	1	2026-02-11 18:25:57.281024	\N
199	19	transfer_in	2	20	40	ISS-20260211-004	\N	Stock Received: ISS-20260211-004 from 15	1	2026-02-11 18:25:57.281025	Main Building - Room 103
200	24	transfer_out	1	150	150	ISS-20260211-005	\N	Stock Issue: ISS-20260211-005 → Main Building - Room 103 - Inventory Management Deployment: Automation_Item_1770463715	1	2026-02-11 18:29:00.556523	\N
201	24	transfer_in	1	150	150	ISS-20260211-005	\N	Stock Received: ISS-20260211-005 from 14	1	2026-02-11 18:29:00.556526	Main Building - Room 103
202	24	in	10	140	1400	PO-20260211-0002	25	Purchase received: PO-20260211-0002	1	2026-02-11 18:30:30.04589	\N
203	25	transfer_out	1	80	80	ISS-20260211-006	\N	Stock Issue: ISS-20260211-006 → Main Building - Room 103 - Inventory Management Deployment: Req_Auto_Item_1770820951	1	2026-02-11 18:31:15.404974	\N
204	25	transfer_in	1	80	80	ISS-20260211-006	\N	Stock Received: ISS-20260211-006 from 14	1	2026-02-11 18:31:15.404977	Main Building - Room 103
205	13	out	0.5	45	22.5	SVC-ASSIGN-17	\N	Service: spa - Room: 103 - From Main inventory 	\N	2026-02-11 18:41:23.590627	Restaurant
206	19	out	1	15	15	SVC-ASSIGN-17	\N	Service: spa - Room: 103 - From Main inventory 	\N	2026-02-11 18:41:23.611148	Restaurant
207	22	transfer_out	1	50	50	ISS-20260211-007	\N	Asset Assigned to Room 103	1	2026-02-11 18:46:13.760904	\N
208	22	transfer_in	1	50	50	ISS-20260211-007	\N	Asset Received from Central Warehouse	1	2026-02-11 18:46:13.760907	Room 103
209	12	transfer_out	1	5000	5000	ISS-20260211-008	\N	Asset Assigned to Room 103	1	2026-02-11 18:46:14.078363	\N
210	12	transfer_in	1	5000	5000	ISS-20260211-008	\N	Asset Received from Central Warehouse	1	2026-02-11 18:46:14.078366	Room 103
211	12	waste	1	5000	5000	LOST-DAM-14	\N	WASTE: Damaged item at checkout - Room 103	1	2026-02-11 18:47:10.762964	\N
212	15	out	0.5	180	90	ORD-9	\N	Food Order #9 Consumption from Global Stock	\N	2026-02-11 18:56:58.103533	Restaurant
213	13	out	0.1	45	4.5	ORD-9	\N	Food Order #9 Consumption from Global Stock	\N	2026-02-11 18:56:58.103537	Restaurant
214	15	out	0.2	180	36	ORD-10	\N	Food Order #10 Consumption from Global Stock	\N	2026-02-11 18:59:32.412573	Restaurant
215	13	out	0.04000000000000001	45	1.8000000000000003	ORD-10	\N	Food Order #10 Consumption from Global Stock	\N	2026-02-11 18:59:32.412577	Restaurant
216	15	out	0.2	180	36	ORD-10	\N	Food Order #10 Consumption from Global Stock	\N	2026-02-11 19:06:22.941686	Restaurant
217	13	out	0.04000000000000001	45	1.8000000000000003	ORD-10	\N	Food Order #10 Consumption from Global Stock	\N	2026-02-11 19:06:22.941689	Restaurant
\.


--
-- Data for Name: journal_entries; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.journal_entries (id, entry_number, entry_date, reference_type, reference_id, description, total_amount, created_by, notes, is_reversed, reversed_entry_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: journal_entry_lines; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.journal_entry_lines (id, entry_id, debit_ledger_id, credit_ledger_id, amount, description, line_number, created_at) FROM stdin;
\.


--
-- Data for Name: key_management; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.key_management (id, key_number, key_type, location_id, room_id, description, current_holder, status, issued_date, returned_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: key_movements; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.key_movements (id, key_id, movement_type, from_user_id, to_user_id, purpose, movement_date, returned_date, notes) FROM stdin;
\.


--
-- Data for Name: laundry_logs; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.laundry_logs (id, item_id, source_location_id, room_number, quantity, status, sent_at, washed_at, returned_at, created_by, notes) FROM stdin;
\.


--
-- Data for Name: laundry_services; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.laundry_services (id, vendor_id, name, contact_person, phone, email, rate_per_kg, rate_per_piece, turnaround_time_days, is_active, notes, created_at) FROM stdin;
\.


--
-- Data for Name: leaves; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.leaves (id, employee_id, from_date, to_date, reason, leave_type, status) FROM stdin;
\.


--
-- Data for Name: legal_documents; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.legal_documents (id, name, document_type, file_path, uploaded_at, description) FROM stdin;
\.


--
-- Data for Name: linen_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.linen_items (id, item_id, rfid_tag, barcode, quality_grade, wash_count, max_washes, current_state, current_location_id, current_room_id, purchase_date, first_use_date, discard_date, discard_reason, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: linen_movements; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.linen_movements (id, item_id, room_id, from_state, to_state, quantity, movement_date, moved_by, notes) FROM stdin;
\.


--
-- Data for Name: linen_stocks; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.linen_stocks (id, item_id, location_id, state, quantity, last_updated) FROM stdin;
\.


--
-- Data for Name: linen_wash_logs; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.linen_wash_logs (id, linen_item_id, wash_date, wash_count_after, quality_after, laundry_provider, cost, notes) FROM stdin;
\.


--
-- Data for Name: location_stocks; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.location_stocks (id, location_id, item_id, quantity, last_updated) FROM stdin;
145	15	15	20	2026-02-11 14:12:34.703802
149	15	21	20	2026-02-11 14:12:34.719972
150	15	20	20	2026-02-11 14:12:34.723778
152	13	22	1	2026-02-11 18:13:12.195537
153	13	12	1	2026-02-11 18:13:12.555351
148	15	18	17	2026-02-11 18:25:57.283801
154	17	19	5	2026-02-11 18:25:57.279155
155	17	18	3	2026-02-11 18:25:57.273549
156	17	24	1	2026-02-11 18:29:00.554401
157	14	24	-1	2026-02-11 18:29:00.55557
158	15	24	10	2026-02-11 18:30:30.017118
159	17	25	1	2026-02-11 18:31:15.402926
160	14	25	-1	2026-02-11 18:31:15.404133
144	15	13	19.5	2026-02-11 18:41:23.583813
147	15	19	14	2026-02-11 18:41:23.602416
146	15	22	18	2026-02-11 18:46:13.748086
161	17	22	1	2026-02-11 18:46:13.760002
151	15	12	18	2026-02-11 18:46:14.06743
162	17	12	0	2026-02-11 18:47:10.751952
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.locations (id, name, code, location_type, parent_location_id, description, is_active, created_at, location_code, is_inventory_point, building, floor, room_area) FROM stdin;
13	Room 001	\N	GUEST_ROOM	\N	Guest room 001 - Deluxe	t	2026-02-11 10:57:48.744106	LOC-RM-001	f	Main Building	\N	Room 001
14	Laundry	\N	LAUNDRY	\N	\N	t	2026-02-11 11:55:35.565105	\N	t	Main Building	\N	Laundry Service
15	Main inventory 	\N	WAREHOUSE	\N		t	2026-02-11 14:00:16.282667	LOC-WH-3	t	main	ground	main
16	Room 102	\N	GUEST_ROOM	\N	Guest room 102 - AC	t	2026-02-11 14:27:18.451619	LOC-RM-102	f	Main Building	\N	Room 102
17	Room 103	\N	GUEST_ROOM	\N	Guest room 103 - Premium	t	2026-02-11 14:27:41.099571	LOC-RM-103	f	Main Building	\N	Room 103
\.


--
-- Data for Name: lost_found; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.lost_found (id, item_description, found_date, found_by, found_by_employee_id, room_number, location, status, claimed_by, claimed_date, claimed_contact, notes, image_url, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: maintenance_tickets; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.maintenance_tickets (id, title, description, category, item_id, location_id, room_id, priority, status, reported_by, assigned_to, created_at, updated_at, resolution_notes, completed_at) FROM stdin;
\.


--
-- Data for Name: nearby_attraction_banners; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.nearby_attraction_banners (id, title, subtitle, image_url, is_active, map_link) FROM stdin;
\.


--
-- Data for Name: nearby_attractions; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.nearby_attractions (id, title, description, image_url, is_active, map_link) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.notifications (id, type, title, message, is_read, created_at, read_at, entity_type, entity_id, recipient_id) FROM stdin;
142	SERVICE	New Cleaning Request	Cleaning request created for Room 001.	f	2026-02-11 11:55:35.581709+00	\N	service_request	29	\N
143	SERVICE	Cleaning Request Updated	Cleaning request for Room 001 is now completed.	f	2026-02-11 12:01:07.122682+00	\N	service_request	29	\N
144	SERVICE	New Cleaning Request	Cleaning request created for Room 001.	f	2026-02-11 12:29:27.228723+00	\N	service_request	30	\N
145	SERVICE	Cleaning Request Updated	Cleaning request for Room 001 is now pending.	f	2026-02-11 14:28:20.978643+00	\N	service_request	30	1
146	SERVICE	Cleaning Request Updated	Cleaning request for Room 001 is now completed.	f	2026-02-11 14:29:41.632304+00	\N	service_request	30	1
147	FOOD_ORDER	Food Order Status Updated	Food order for Room 103 is now in_progress.	f	2026-02-11 18:06:10.491496+00	\N	food_order	6	\N
148	FOOD_ORDER	Food Order Status Updated	Food order for Room 103 is now completed.	f	2026-02-11 18:06:24.239542+00	\N	food_order	6	\N
149	FOOD_ORDER	Food Order Status Updated	Food order for Room 103 is now completed.	f	2026-02-11 18:06:34.572935+00	\N	food_order	7	\N
150	SERVICE	Delivery Request Updated	Delivery request for Room 103 is now in_progress.	f	2026-02-11 18:19:33.241839+00	\N	service_request	31	1
151	SERVICE	Delivery Request Updated	Delivery request for Room 103 is now in_progress.	f	2026-02-11 18:19:41.966663+00	\N	service_request	32	1
152	SERVICE	Delivery Request Updated	Delivery request for Room 103 is now completed.	f	2026-02-11 18:19:44.633455+00	\N	service_request	31	1
153	SERVICE	Delivery Request Updated	Delivery request for Room 103 is now completed.	f	2026-02-11 18:19:47.675496+00	\N	service_request	32	1
154	SERVICE	Service Assigned	Service 'DEluxe and Ac' assigned to harry for Room 103.	f	2026-02-11 18:34:06.077081+00	\N	assigned_service	15	1
155	SERVICE	Service Assigned	Service 'DEluxe and Ac' assigned to harry for Room 103.	f	2026-02-11 18:34:06.101816+00	\N	assigned_service	15	\N
156	FOOD_ORDER	New Food Order	New food order received for Room 103.	f	2026-02-11 18:36:56.590587+00	\N	food_order	8	\N
157	FOOD_ORDER	Food Order Status Updated	Food order for Room 103 is now in_progress.	f	2026-02-11 18:37:03.725354+00	\N	food_order	8	1
158	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to in_progress.	f	2026-02-11 18:37:14.589694+00	\N	assigned_service	15	1
159	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to ServiceStatus.in_progress.	f	2026-02-11 18:37:14.61983+00	\N	assigned_service	15	\N
160	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to completed.	f	2026-02-11 18:37:19.44052+00	\N	assigned_service	15	1
161	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to ServiceStatus.completed.	f	2026-02-11 18:37:19.482009+00	\N	assigned_service	15	\N
162	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to completed.	f	2026-02-11 18:37:26.913742+00	\N	assigned_service	15	1
163	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to ServiceStatus.completed.	f	2026-02-11 18:37:26.946953+00	\N	assigned_service	15	\N
164	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to completed.	f	2026-02-11 18:37:30.808443+00	\N	assigned_service	15	1
165	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to ServiceStatus.completed.	f	2026-02-11 18:37:30.832415+00	\N	assigned_service	15	\N
166	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to completed.	f	2026-02-11 18:37:31.797818+00	\N	assigned_service	15	1
167	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to completed.	f	2026-02-11 18:37:31.798475+00	\N	assigned_service	15	1
168	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to ServiceStatus.completed.	f	2026-02-11 18:37:31.827731+00	\N	assigned_service	15	\N
169	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to ServiceStatus.completed.	f	2026-02-11 18:37:31.837324+00	\N	assigned_service	15	\N
170	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to completed.	f	2026-02-11 18:37:32.045413+00	\N	assigned_service	15	1
171	SERVICE	Service Status Updated	Service 'DEluxe and Ac' status changed to ServiceStatus.completed.	f	2026-02-11 18:37:32.071772+00	\N	assigned_service	15	\N
172	SERVICE	Service Assigned	Service 'spa' assigned to harry for Room 103.	f	2026-02-11 18:39:38.927344+00	\N	assigned_service	16	1
173	SERVICE	Service Assigned	Service 'spa' assigned to harry for Room 103.	f	2026-02-11 18:39:38.942025+00	\N	assigned_service	16	\N
174	SERVICE	Service Status Updated	Service 'spa' status changed to in_progress.	f	2026-02-11 18:40:29.38764+00	\N	assigned_service	16	1
175	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.in_progress.	f	2026-02-11 18:40:29.408724+00	\N	assigned_service	16	\N
176	SERVICE	Service Status Updated	Service 'spa' status changed to completed.	f	2026-02-11 18:40:33.281685+00	\N	assigned_service	16	1
177	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.completed.	f	2026-02-11 18:40:33.320836+00	\N	assigned_service	16	\N
178	SERVICE	Service Assigned	Service 'spa' assigned to harry for Room 103.	f	2026-02-11 18:41:23.624227+00	\N	assigned_service	17	1
179	SERVICE	Service Assigned	Service 'spa' assigned to harry for Room 103.	f	2026-02-11 18:41:23.641317+00	\N	assigned_service	17	\N
180	SERVICE	Service Status Updated	Service 'spa' status changed to in_progress.	f	2026-02-11 18:41:29.601347+00	\N	assigned_service	17	1
181	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.in_progress.	f	2026-02-11 18:41:29.617554+00	\N	assigned_service	17	\N
182	SERVICE	Service Status Updated	Service 'spa' status changed to completed.	f	2026-02-11 18:41:50.0245+00	\N	assigned_service	17	1
183	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.completed.	f	2026-02-11 18:41:50.063876+00	\N	assigned_service	17	\N
184	FOOD_ORDER	Food Order Status Updated	Food order for Room 103 is now completed.	f	2026-02-11 18:50:12.558858+00	\N	food_order	8	1
185	SERVICE	Delivery Request Updated	Delivery request for Room 103 is now in_progress.	f	2026-02-11 18:50:59.060663+00	\N	service_request	33	1
186	SERVICE	Service Status Updated	Service 'spa' status changed to completed.	f	2026-02-11 18:51:00.990812+00	\N	assigned_service	17	1
187	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.completed.	f	2026-02-11 18:51:01.023779+00	\N	assigned_service	17	\N
188	SERVICE	New Cleaning Request	Cleaning request created for Room 103.	f	2026-02-11 18:51:54.239019+00	\N	service_request	35	\N
189	SERVICE	Service Status Updated	Service 'spa' status changed to completed.	f	2026-02-11 18:52:18.100446+00	\N	assigned_service	17	1
190	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.completed.	f	2026-02-11 18:52:18.131767+00	\N	assigned_service	17	\N
191	SERVICE	Replenishment Request Updated	Replenishment request for Room 103 is now completed.	f	2026-02-11 18:52:25.311386+00	\N	service_request	34	\N
192	SERVICE	Cleaning Request Updated	Cleaning request for Room 103 is now completed.	f	2026-02-11 18:52:30.693089+00	\N	service_request	35	\N
193	SERVICE	Service Status Updated	Service 'spa' status changed to completed.	f	2026-02-11 18:52:34.287852+00	\N	assigned_service	17	1
194	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.completed.	f	2026-02-11 18:52:34.329768+00	\N	assigned_service	17	\N
196	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.completed.	f	2026-02-11 18:52:39.039812+00	\N	assigned_service	17	\N
198	SERVICE	Service Status Updated	Service 'spa' status changed to ServiceStatus.completed.	f	2026-02-11 18:52:48.646495+00	\N	assigned_service	17	\N
195	SERVICE	Service Status Updated	Service 'spa' status changed to completed.	f	2026-02-11 18:52:39.00794+00	\N	assigned_service	17	1
197	SERVICE	Service Status Updated	Service 'spa' status changed to completed.	f	2026-02-11 18:52:48.616931+00	\N	assigned_service	17	1
199	FOOD_ORDER	New Food Order	New food order received for Room 102.	f	2026-02-11 18:56:47.536535+00	\N	food_order	9	\N
200	FOOD_ORDER	Food Order Status Updated	Food order for Room 102 is now completed.	f	2026-02-11 18:56:58.065221+00	\N	food_order	9	1
201	FOOD_ORDER	New Food Order	New food order received for Room 001.	f	2026-02-11 18:59:21.681255+00	\N	food_order	10	\N
202	FOOD_ORDER	Food Order Status Updated	Food order for Room 001 is now completed.	f	2026-02-11 18:59:32.386657+00	\N	food_order	10	1
203	SERVICE	Delivery Request Updated	Delivery request for Room 001 is now in_progress.	f	2026-02-11 19:04:12.53415+00	\N	service_request	36	1
204	FOOD_ORDER	Food Order Status Updated	Food order for Room 001 is now in_progress.	f	2026-02-11 19:05:49.217519+00	\N	food_order	10	1
205	FOOD_ORDER	Food Order Status Updated	Food order for Room 001 is now completed.	f	2026-02-11 19:06:22.914241+00	\N	food_order	10	1
206	SERVICE	Delivery Request Updated	Delivery request for Room 001 is now completed.	f	2026-02-11 19:06:46.890959+00	\N	service_request	36	1
207	SERVICE	New Cleaning Request	Cleaning request created for Room 001.	f	2026-02-11 19:07:38.055138+00	\N	service_request	37	\N
208	SERVICE	Cleaning Request Updated	Cleaning request for Room 001 is now in_progress.	f	2026-02-11 19:23:20.942531+00	\N	service_request	37	\N
209	SERVICE	Cleaning Request Updated	Cleaning request for Room 001 is now completed.	f	2026-02-11 19:23:23.994307+00	\N	service_request	37	\N
210	SERVICE	New Cleaning Request	Cleaning request created for Room 103.	f	2026-02-11 19:25:22.06796+00	\N	service_request	38	\N
211	SERVICE	Cleaning Request Updated	Cleaning request for Room 103 is now pending.	f	2026-02-12 08:14:46.735949+00	\N	service_request	38	45
212	SERVICE	Cleaning Request Updated	Cleaning request for Room 103 is now in_progress.	f	2026-02-12 08:14:53.990829+00	\N	service_request	38	45
213	SERVICE	Cleaning Request Updated	Cleaning request for Room 103 is now completed.	f	2026-02-12 08:15:07.656565+00	\N	service_request	38	45
\.


--
-- Data for Name: office_inventory_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.office_inventory_items (id, item_id, item_type, department_id, location_id, assigned_to, asset_tag, serial_number, purchase_date, purchase_price, warranty_expiry, amc_expiry, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: office_requisitions; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.office_requisitions (id, req_number, item_id, requested_by, department_id, quantity, uom, purpose, status, supervisor_approval, admin_approval, approved_date, issued_date, issued_by, notes, created_at) FROM stdin;
\.


--
-- Data for Name: outlet_stocks; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.outlet_stocks (id, outlet_id, item_id, quantity, uom, par_level, last_updated) FROM stdin;
\.


--
-- Data for Name: outlets; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.outlets (id, name, code, location_id, outlet_type, is_active, description, created_at) FROM stdin;
\.


--
-- Data for Name: package_booking_rooms; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.package_booking_rooms (id, package_booking_id, room_id) FROM stdin;
2	2	7
3	3	9
4	4	8
\.


--
-- Data for Name: package_bookings; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.package_bookings (id, package_id, user_id, guest_name, guest_email, guest_mobile, check_in, check_out, adults, children, id_card_image_url, guest_photo_url, status, advance_deposit, checked_in_at, food_preferences, special_requests, total_amount) FROM stdin;
2	16	1	Basil Abraham	basilabraham44@gmail.com	09605620416	2026-02-11	2026-02-12	2	0	id_pkg_2_58eb7e14c9bb434485f6b5bf2a3dde65.jpg	guest_pkg_2_bf15fce2bf024242b6dd4211d96a3fbf.jpg	checked_out	0	2026-02-11 11:59:18.175585	\N	\N	12000
4	20	1	subin	subin@gmail.con	2727272727	2026-02-11	2026-02-12	2	0	id_pkg_4_c853d78f7b98495bb0fea9329a43d2c5.jpg	guest_pkg_4_8386e3649dbb454789b84d31d0b51e43.jpg	checked-in	0	2026-02-11 15:44:53.706462	\N	\N	15000
3	19	1	alphi	alphi@gmail.com	2727198291	2026-02-11	2026-02-12	2	0	id_pkg_3_ccb089eb2e0f4865b5c3821b9c23d33d.jpg	guest_pkg_3_576293bc27634246a3e2641761c5bd61.jpg	checked_out	0	2026-02-11 15:43:15.826366	\N	\N	12000
\.


--
-- Data for Name: package_images; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.package_images (id, package_id, image_url) FROM stdin;
19	16	/uploads/packages/pkg_1e53d6223a9c478ebfd87de2c9452e60_blob
20	17	/uploads/packages/pkg_b34221a53a9a4a07b45c1b1f86f33dcb_blob
22	19	/uploads/packages/pkg_8b103ec2aa1449f0b8ff540dc02c8eb6_blob
23	20	/uploads/packages/pkg_b1ff1a19b5054c2a871e85bfb4bbed70_blob
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.packages (id, title, description, price, booking_type, room_types, theme, default_adults, default_children, max_stay_days, food_included, food_timing, complimentary, status) FROM stdin;
16	hhhhhhhh	asdfghjk	12000	room_type	Deluxe	\N	2	0	\N	Breakfast,Snacks	{"Breakfast":{"time":"08:00","items":[]},"Snacks":{"time":"18:02","items":[{"id":4,"qty":1}]}}	xcvbnm,	active
17	new	dfghjkl	10000	room_type	Deluxe	\N	2	0	\N	Breakfast,Dinner	{"Breakfast":{"time":"08:00","items":[{"id":5,"qty":1}]},"Lunch":{"time":"13:00","items":[]},"Dinner":{"time":"21:00","items":[{"id":4,"qty":1}]}}	\N	active
19	test		12000	room_type	Premium	\N	2	0	\N	Breakfast,Dinner	{"Breakfast":{"time":"08:00","items":[{"id":5,"qty":1}]},"Dinner":{"time":"22:00","items":[{"id":4,"qty":1}]}}	ggggggg	active
20	acpack		15000	room_type	AC	\N	2	0	\N	Breakfast,Dinner	{"Breakfast":{"time":"08:00","items":[{"id":5,"qty":1}]},"Dinner":{"time":"22:00","items":[{"id":4,"qty":1}]}}	\N	active
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.payments (id, booking_id, amount, method, status, created_at) FROM stdin;
\.


--
-- Data for Name: perishable_batches; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.perishable_batches (id, item_id, location_id, batch_number, quantity, uom, expiry_date, received_date, created_at) FROM stdin;
\.


--
-- Data for Name: plan_weddings; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.plan_weddings (id, title, description, image_url, is_active) FROM stdin;
\.


--
-- Data for Name: po_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.po_items (id, po_id, item_id, quantity, uom, unit_price, total_price, received_quantity) FROM stdin;
\.


--
-- Data for Name: purchase_details; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.purchase_details (id, purchase_master_id, item_id, hsn_code, quantity, unit, unit_price, gst_rate, cgst_amount, sgst_amount, igst_amount, discount, total_amount, notes) FROM stdin;
28	24	13	09876	20	liter	45.00	5.00	22.50	22.50	0.00	0.00	945.00	Serial/Batch: N/A, Expiry: 2026-02-11
29	24	15	7656	20	kg	180.00	5.00	90.00	90.00	0.00	0.00	3780.00	Serial/Batch: N/A, Expiry: 2026-02-14
30	24	22	43545	20	pcs	50.00	18.00	90.00	90.00	0.00	0.00	1180.00	\N
31	24	19	4545	20	pcs	15.00	18.00	27.00	27.00	0.00	0.00	354.00	Serial/Batch: N/A, Expiry: 2026-02-14
32	24	18	342343	20	pcs	20.00	18.00	36.00	36.00	0.00	0.00	472.00	Serial/Batch: N/A, Expiry: 2026-03-07
33	24	21	54656	20	pcs	50.00	12.00	60.00	60.00	0.00	0.00	1120.00	\N
34	24	20	435435	20	pcs	100.00	12.00	120.00	120.00	0.00	0.00	2240.00	\N
35	24	12	090909	20	pcs	5000.00	18.00	9000.00	9000.00	0.00	0.00	118000.00	\N
36	25	24	123456	10	kg	140.00	5.00	35.00	35.00	0.00	0.00	1470.00	\N
\.


--
-- Data for Name: purchase_entries; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.purchase_entries (id, entry_number, invoice_number, invoice_date, vendor_id, vendor_address, vendor_gstin, tax_inclusive, taxable_amount, total_gst_amount, total_invoice_value, status, location_id, created_by, created_at, updated_at, notes) FROM stdin;
\.


--
-- Data for Name: purchase_entry_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.purchase_entry_items (id, purchase_entry_id, item_id, hsn_code, uom, gst_rate, quantity, rate, base_amount, gst_amount, total_amount, stock_updated, stock_level_id) FROM stdin;
\.


--
-- Data for Name: purchase_masters; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.purchase_masters (id, purchase_number, vendor_id, purchase_date, expected_delivery_date, invoice_number, invoice_date, gst_number, payment_terms, payment_status, sub_total, cgst, sgst, igst, discount, total_amount, notes, status, created_by, created_at, updated_at, payment_method, destination_location_id) FROM stdin;
24	PO-20260211-0001	1	2026-02-11	2026-02-21	\N	\N	\N	\N	paid	109200.00	9445.50	9445.50	0.00	0.00	128091.00	\N	received	1	2026-02-11 14:11:29.675386	2026-02-11 14:12:34.771296	\N	15
25	PO-20260211-0002	10	2026-02-11	2026-02-11	\N	\N	\N	\N	paid	1400.00	35.00	35.00	0.00	0.00	1470.00	\N	received	1	2026-02-11 18:30:29.969636	2026-02-11 18:30:30.043599	\N	15
\.


--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.purchase_orders (id, po_number, indent_id, vendor_name, vendor_email, vendor_phone, status, total_amount, created_by, approved_by, created_at, sent_at, expected_delivery_date, notes) FROM stdin;
\.


--
-- Data for Name: recipe_ingredients; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.recipe_ingredients (id, recipe_id, inventory_item_id, quantity, unit, notes, created_at) FROM stdin;
14	6	15	0.5	kg		2026-02-11 18:17:22.70775
15	6	13	0.1	liter		2026-02-11 18:17:22.707755
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.recipes (id, food_item_id, name, description, servings, prep_time_minutes, cook_time_minutes, created_at, updated_at) FROM stdin;
6	4	briyani rec		5	60	120	2026-02-11 18:16:44.068489	2026-02-11 18:16:44.068493
\.


--
-- Data for Name: resort_info; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.resort_info (id, name, address, facebook, instagram, twitter, linkedin, is_active) FROM stdin;
\.


--
-- Data for Name: restock_alerts; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.restock_alerts (id, item_id, location_id, current_stock, min_stock, alert_type, status, created_at, acknowledged_at, acknowledged_by, resolved_at, resolved_by, notes) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.reviews (id, name, comment, rating, is_active) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.roles (id, name, permissions) FROM stdin;
2	guest	["view"]
1	admin	["/dashboard", "/bookings", "/rooms", "/services", "/expenses", "/food-orders", "/food-categories", "/food-items", "/billing", "/packages", "/users", "/roles", "/employees", "/reports", "/account", "/userfrontend_data", "/guestprofiles", "/employee-management"]
4	manager	["/services","/food-orders","/employee-management","/roles","/expenses","/food-categories","/dashboard","/account","/account/reports","/account/chart-of-accounts"]
5	Housekeeping	housekeeping_access
6	Kitchen	kitchen_access
7	Waiter	waiter_access
\.


--
-- Data for Name: room_assets; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.room_assets (id, room_id, item_id, asset_id, qr_code, serial_number, status, purchase_date, purchase_price, last_inspection_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: room_consumable_assignments; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.room_consumable_assignments (id, room_id, booking_id, assigned_at, assigned_by, notes) FROM stdin;
\.


--
-- Data for Name: room_consumable_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.room_consumable_items (id, assignment_id, item_id, quantity_assigned, uom) FROM stdin;
\.


--
-- Data for Name: room_inventory_audits; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.room_inventory_audits (id, room_id, room_inventory_item_id, expected_quantity, found_quantity, consumed_quantity, billed_amount, audit_date, audited_by, notes) FROM stdin;
\.


--
-- Data for Name: room_inventory_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.room_inventory_items (id, room_id, item_id, par_stock, current_stock, last_audit_date, last_audited_by, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.rooms (id, number, type, price, status, image_url, adults, children, air_conditioning, wifi, bathroom, living_area, terrace, parking, kitchen, family_room, bbq, garden, dining, breakfast, inventory_location_id, housekeeping_updated_at, last_maintenance_date, housekeeping_status, extra_images) FROM stdin;
8	102	AC	5000	Checked-in	\N	2	0	f	f	f	f	f	f	f	f	f	f	f	f	16	\N	\N	Clean	\N
7	001	Deluxe	2000	Available	/uploads/rooms/room_bb2333785c6a4a92a9e444450e3f6fc3.jpg	2	0	f	f	f	f	f	f	f	f	f	f	f	f	13	\N	\N	Clean	\N
9	103	Premium	10000	Available	\N	2	0	f	f	f	f	f	f	f	f	f	f	f	f	17	\N	\N	Clean	\N
\.


--
-- Data for Name: salary_payments; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.salary_payments (id, employee_id, month, year, month_number, basic_salary, allowances, deductions, net_salary, payment_date, payment_method, payment_status, created_at, notes) FROM stdin;
\.


--
-- Data for Name: security_equipment; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.security_equipment (id, equipment_type, item_id, asset_id, qr_code, location_id, manufacturer, model, serial_number, ip_address, installation_date, warranty_expiry, amc_expiry, status, assigned_to, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: security_maintenance; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.security_maintenance (id, equipment_id, maintenance_type, scheduled_date, completed_date, service_provider, cost, performed_by, description, next_service_due, notes, created_at) FROM stdin;
\.


--
-- Data for Name: security_uniforms; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.security_uniforms (id, item_id, employee_id, size, quantity, issued_date, return_date, condition, replacement_required, notes, created_at) FROM stdin;
\.


--
-- Data for Name: service_images; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.service_images (id, service_id, image_url) FROM stdin;
\.


--
-- Data for Name: service_inventory_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.service_inventory_items (service_id, inventory_item_id, quantity, created_at) FROM stdin;
4	13	0.5	2026-02-11 18:40:17.949604
4	19	1	2026-02-11 18:40:17.955095
\.


--
-- Data for Name: service_requests; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.service_requests (id, food_order_id, room_id, employee_id, request_type, description, status, created_at, completed_at, refill_data, image_path) FROM stdin;
29	\N	7	\N	cleaning	Room cleaning required after checkout - Room 001 (Guest: dfghjk)	completed	2026-02-11 11:55:35.574163	2026-02-11 12:01:07.117596	\N	\N
30	\N	7	5	cleaning	Room cleaning required after checkout - Room 001 (Guest: Basil Abraham)	completed	2026-02-11 12:29:27.222406	2026-02-11 14:29:41.589347	\N	\N
31	6	9	5	delivery	SCHEDULED_FOR: 2026-02-11 09:00:00 -- Package Meal: Breakfast	completed	2026-02-11 18:06:24.261233	2026-02-11 18:19:44.616791	\N	\N
32	7	9	5	delivery	SCHEDULED_FOR: 2026-02-11 23:00:00 -- Package Meal: Dinner	completed	2026-02-11 18:06:34.590382	2026-02-11 18:19:47.663679	\N	\N
34	\N	9	\N	replenishment	REPLACEMENT: Asset Tv (Tag: N/A) requested for Room 103 during checkout.	completed	2026-02-11 18:47:10.75321	2026-02-11 18:52:25.30486	\N	\N
35	\N	9	\N	cleaning	Room cleaning required after checkout - Room 103 (Guest: alphi)	completed	2026-02-11 18:51:54.234642	2026-02-11 18:52:30.687496	\N	\N
36	10	7	5	delivery	Room service delivery for food order #10	completed	2026-02-11 18:59:21.671573	2026-02-11 19:06:46.877233	\N	\N
37	\N	7	\N	cleaning	Room cleaning required after checkout - Room 001 (Guest: daion)	completed	2026-02-11 19:07:38.049362	2026-02-11 19:23:23.986021	\N	\N
38	\N	9	10	cleaning	Room cleaning required after checkout - Room 103 (Guest: mathew)	completed	2026-02-11 19:25:22.062415	2026-02-12 08:15:07.640768	\N	\N
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.services (id, name, description, charges, created_at, is_visible_to_guest, average_completion_time, gst_rate) FROM stdin;
4	spa	ayurveda	2000	2026-02-06 11:27:44.644372	t	30mins	0.18
5	DEluxe and Ac	Good time offered for low price	3000	2026-02-09 08:38:11.429349	t	30mins	0.18
\.


--
-- Data for Name: signature_experiences; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.signature_experiences (id, title, description, image_url, is_active) FROM stdin;
\.


--
-- Data for Name: stock_issue_details; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.stock_issue_details (id, issue_id, item_id, issued_quantity, unit, unit_price, notes, batch_lot_number, cost, is_payable, is_paid, rental_price, is_damaged, damage_notes) FROM stdin;
36	28	22	1	pcs	50	Asset Mapping ID: 7	\N	50	f	f	\N	f	\N
37	29	12	1	pcs	5000	Asset Mapping ID: 8	\N	5000	f	f	\N	f	\N
38	30	19	3	pcs	20		\N	60	f	f	\N	f	\N
39	31	18	3	pcs	40		\N	120	f	f	\N	f	\N
40	31	19	2	pcs	20		\N	40	f	f	\N	f	\N
41	32	24	1	pcs	150	\N	\N	150	t	f	153	f	\N
42	33	25	1	pcs	80	\N	\N	80	t	f	80	f	\N
43	34	22	1	pcs	50	Asset Mapping ID: 9	\N	50	f	f	\N	f	\N
44	35	12	1	pcs	5000	Asset Mapping ID: 10	\N	5000	f	f	\N	f	\N
\.


--
-- Data for Name: stock_issues; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.stock_issues (id, issue_number, requisition_id, issued_by, issue_date, notes, created_at, source_location_id, destination_location_id) FROM stdin;
28	ISS-20260211-001	\N	1	2026-02-11 18:13:12.179235	Auto-generated from Asset Assignment to Room 001	2026-02-11 18:13:12.189631	15	13
29	ISS-20260211-002	\N	1	2026-02-11 18:13:12.543548	Auto-generated from Asset Assignment to Room 001	2026-02-11 18:13:12.550597	15	13
30	ISS-20260211-003	\N	1	2026-02-11 18:25:08	Extra allocation for booking BK-000003 (0 payable, 3 comp) - Source: 15	2026-02-11 18:25:10.012614	15	17
31	ISS-20260211-004	\N	1	2026-02-11 18:25:55	Extra allocation for booking BK-000003 (0 payable, 5 comp) - Source: 15	2026-02-11 18:25:57.266705	15	17
32	ISS-20260211-005	\N	1	2026-02-11 18:28:58.587	Inventory Management Deployment: Automation_Item_1770463715	2026-02-11 18:29:00.546695	14	17
33	ISS-20260211-006	\N	1	2026-02-11 18:31:13.524	Inventory Management Deployment: Req_Auto_Item_1770820951	2026-02-11 18:31:15.395468	14	17
34	ISS-20260211-007	\N	1	2026-02-11 18:46:13.753385	Auto-generated from Asset Assignment to Room 103	2026-02-11 18:46:13.756946	15	17
35	ISS-20260211-008	\N	1	2026-02-11 18:46:14.071499	Auto-generated from Asset Assignment to Room 103	2026-02-11 18:46:14.074535	15	17
\.


--
-- Data for Name: stock_levels; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.stock_levels (id, item_id, location_id, quantity, uom, expiry_date, batch_number, last_updated) FROM stdin;
\.


--
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.stock_movements (id, item_id, movement_type, from_location_id, to_location_id, quantity, uom, batch_number, expiry_date, movement_date, moved_by, reference_number, notes, created_at) FROM stdin;
\.


--
-- Data for Name: stock_requisition_details; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.stock_requisition_details (id, requisition_id, item_id, requested_quantity, unit, notes, approved_quantity) FROM stdin;
2	2	25	15	kg	Urgent	\N
\.


--
-- Data for Name: stock_requisitions; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.stock_requisitions (id, requisition_number, destination_department, requested_by, status, notes, approved_by, approved_at, created_at, updated_at, date_needed, priority) FROM stdin;
2	REQ-20260211-001	Security	1	pending	Restock Req_Auto_Item_1770820951	\N	\N	2026-02-11 14:42:39.952386	2026-02-11 14:42:39.95239	2026-03-15	
\.


--
-- Data for Name: stock_usage; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.stock_usage (id, item_id, location_id, quantity, uom, usage_type, recipe_id, food_order_id, usage_date, used_by, notes) FROM stdin;
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.system_settings (id, key, value, description, updated_at) FROM stdin;
\.


--
-- Data for Name: units_of_measurement; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.units_of_measurement (id, name, symbol, description, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: uom_conversions; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.uom_conversions (id, item_id, from_uom, to_uom, conversion_factor) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.users (id, name, email, hashed_password, phone, is_active, role_id) FROM stdin;
1	harry	admin@orchid.com	$2b$12$TxbKp6O90fSRrhDRSGGIC.p9ly.uZEETxPwX7OB3yfXzcANRmRPde	\N	t	1
52	Basil Abraham	basilabraham44@gmail.com	$2b$12$0qjpQKbq8W1gZY0oph2jyOOnjMGrJEIdjM/0qcS.SCnmY3KxkuS0i	09605620416	t	2
45	Maine	a@orchid.com	$2b$12$SXXo73i1JLX/aNRxaKBSX.0ySOuyRDhue5avpOv5C.dZSdOx0f792	043210	t	4
44	ha	pomma@teqmates.com	$2b$12$IVn3v7JzP7KjssNI5jYo5.JksYXWqsf3I2qNiGJgpyey9PY2fWc9W	0909090909	t	2
46	TEast3	goodwkjkj@gmail.com	$2b$12$E2THcE0xItn9lq/FmxjqQeMf3YyhE.IIFwpG8ausGcSYhW.rkwmgq	989898989890	t	2
48	new test	goodgfghgfh@gmail.com	$2b$12$6Fqby2PfPPoACpkDJAPdrulD52/iS/Df0ESYyHO5EEkCeFjPlet3u	23454254354	t	2
49	price	goofhggfhgfh@gmail.com	$2b$12$oa.mbgh3JnQ64ABnfAkgZu9KTfBl91QufQGthVwhJ3MdFvA6ENyQK	6756756767	t	2
47	daion	daion@gmail.com	$2b$12$lkHHzmC4XM7ets7oOZmH8.tPl2wm8d/LKBJ6n6aP/AXI.PS4naIey	9961239861	t	2
50	anil	anil@gmail.com	$2b$12$2eGBOJ/Hbbsjxm3ez09O9uERycO68ABAR5.Xi9ihnSPCVi1NJ4I7K	8882882818	t	2
51	dfghjk	asdf@gmail.com	$2b$12$2bqZ/oanqWZ57WStpXYDw.RCKKSLGKaeNyEuWCIDIR6CzOM/HBz72	23124243	t	2
53	alphi	alphi@gmail.com	$2b$12$876CfYDdqTSfrkqeIzxUAu8s8YlhkQMmWc/.kaqtn07GqNcrG7I5u	2727198291	t	2
54	subin	subin@gmail.con	$2b$12$AXOuL8v4Hi5XoKd4EpNp5OpL9UnWuh95xeoHIQPnNANeHK/vpRil.	2727272727	t	2
55	mathew	mathew@gmail.com	$2b$12$ZH1GA84/xiMym37OEHadROenQXIjx2n7LKtHUNAYWURa0t1CDZO6q	81812882	t	2
\.


--
-- Data for Name: vendor_items; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.vendor_items (id, vendor_id, item_id, unit_price, uom, effective_from, effective_to, is_current, notes, created_at) FROM stdin;
\.


--
-- Data for Name: vendor_performance; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.vendor_performance (id, vendor_id, period_start, period_end, on_time_delivery_rate, quality_score, price_competitiveness, total_orders, total_value, notes, created_at) FROM stdin;
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.vendors (id, name, company_name, gst_registration_type, gst_number, legal_name, trade_name, pan_number, qmp_scheme, msme_udyam_no, contact_person, email, phone, billing_address, billing_state, shipping_address, distance_km, address, city, state, pincode, country, is_msme_registered, tds_apply, rcm_applicable, payment_terms, preferred_payment_method, account_holder_name, bank_name, account_number, ifsc_code, branch_name, upi_id, upi_mobile_number, notes, is_active, created_at, updated_at) FROM stdin;
1	General Supplier	\N	\N	29ABCDE1234F1Z5	\N	\N	\N	f	\N	John Doe	supplier@example.com	9876543210	\N	\N	\N	\N	123 Industrial Area	\N	\N	\N	India	f	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-01-06 06:35:12.061881	2026-01-06 06:35:12.061891
7	etygug	new	Regular	27AAACM3025E1ZZ	adskdskdk	\N	AAACM3025E	f	\N	\N	\N	\N	skldklskdsls	Chhattisgarh	\N	\N	\N	\N	\N	\N	India	f	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-02-07 12:49:30.355384	2026-02-07 12:49:30.355389
10	UniqueVendor_1770468779	\N	Regular	29ABCDE5843F1Z5	Unique Legal 1770468779	\N	ABCDE5843F	f	\N	\N	\N	\N	Unique Address 1770468779	Karnataka	\N	\N	\N	\N	\N	\N	India	f	f	f	\N	Cash	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-02-07 12:53:10.12471	2026-02-07 12:53:10.124715
11	Automation_Vendor_1770468815	Auto-procure Corp	Regular	29ABCDE5879F1Z5	Automation Procurement Solutions Private Limited	\N	ABCDE5879F	f	\N	\N	\N	\N	123 Inventory Street, Tech Park	Karnataka	\N	15	\N	\N	\N	\N	India	f	f	f	30	Cash	\N	\N	\N	\N	\N	\N	\N	Vendor added for automation testing	t	2026-02-07 12:53:46.104825	2026-02-07 12:53:46.104831
12	Composition_Vendor_1770469482	Composition Corp	Composition	\N	Composition Legal Name	\N	ABCDE1234F	f	UDYAM-KA-69482-XXXXX	\N	\N	\N	456 No-GST Road, Bangalore	Karnataka	\N	\N	\N	\N	\N	\N	India	f	f	f	\N	Cash	\N	\N	\N	\N	\N	\N	\N	Testing composition vendor creation	t	2026-02-07 13:04:54.11441	2026-02-07 13:04:54.114415
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.vouchers (id, code, discount_percent, expiry_date) FROM stdin;
\.


--
-- Data for Name: wastage_logs; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.wastage_logs (id, item_id, location_id, quantity, uom, reason, wastage_date, logged_by, notes) FROM stdin;
\.


--
-- Data for Name: waste_logs; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.waste_logs (id, item_id, batch_number, expiry_date, quantity, unit, reason_code, photo_path, notes, reported_by, created_at, log_number, location_id, action_taken, waste_date, food_item_id, is_food_item) FROM stdin;
\.


--
-- Data for Name: work_order_part_issues; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.work_order_part_issues (id, work_order_id, item_id, quantity, uom, from_location_id, issued_by, issued_date, notes) FROM stdin;
\.


--
-- Data for Name: work_order_parts; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.work_order_parts (id, work_order_id, item_id, quantity_required, quantity_issued, uom, notes) FROM stdin;
\.


--
-- Data for Name: work_orders; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.work_orders (id, wo_number, asset_id, location_id, title, description, work_type, priority, status, reported_by, assigned_to, scheduled_date, started_date, completed_date, estimated_cost, actual_cost, service_provider, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: working_logs; Type: TABLE DATA; Schema: public; Owner: orchid_user
--

COPY public.working_logs (id, employee_id, date, check_in_time, check_out_time, location) FROM stdin;
\.


--
-- Name: account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.account_groups_id_seq', 6, true);


--
-- Name: account_ledgers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.account_ledgers_id_seq', 27, true);


--
-- Name: activity_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.activity_logs_id_seq', 8623, true);


--
-- Name: approval_matrices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.approval_matrices_id_seq', 1, false);


--
-- Name: approval_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.approval_requests_id_seq', 1, false);


--
-- Name: asset_inspections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.asset_inspections_id_seq', 1, false);


--
-- Name: asset_maintenance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.asset_maintenance_id_seq', 1, false);


--
-- Name: asset_mappings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.asset_mappings_id_seq', 10, true);


--
-- Name: asset_registry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.asset_registry_id_seq', 1, false);


--
-- Name: assigned_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.assigned_services_id_seq', 17, true);


--
-- Name: attendances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.attendances_id_seq', 1, false);


--
-- Name: audit_discrepancies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.audit_discrepancies_id_seq', 1, false);


--
-- Name: booking_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.booking_rooms_id_seq', 16, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.bookings_id_seq', 16, true);


--
-- Name: check_availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.check_availability_id_seq', 1, false);


--
-- Name: checklist_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.checklist_executions_id_seq', 1, false);


--
-- Name: checklist_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.checklist_items_id_seq', 1, false);


--
-- Name: checklist_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.checklist_responses_id_seq', 1, false);


--
-- Name: checklists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.checklists_id_seq', 1, false);


--
-- Name: checkout_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.checkout_payments_id_seq', 27, true);


--
-- Name: checkout_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.checkout_requests_id_seq', 16, true);


--
-- Name: checkout_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.checkout_verifications_id_seq', 25, true);


--
-- Name: checkouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.checkouts_id_seq', 27, true);


--
-- Name: consumable_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.consumable_usage_id_seq', 1, false);


--
-- Name: cost_centers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.cost_centers_id_seq', 1, false);


--
-- Name: damage_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.damage_reports_id_seq', 1, false);


--
-- Name: employee_inventory_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.employee_inventory_assignments_id_seq', 42, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.employees_id_seq', 10, true);


--
-- Name: eod_audit_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.eod_audit_items_id_seq', 1, false);


--
-- Name: eod_audits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.eod_audits_id_seq', 1, false);


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.expenses_id_seq', 1, false);


--
-- Name: expiry_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.expiry_alerts_id_seq', 1, false);


--
-- Name: fire_safety_equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.fire_safety_equipment_id_seq', 1, false);


--
-- Name: fire_safety_incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.fire_safety_incidents_id_seq', 1, false);


--
-- Name: fire_safety_inspections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.fire_safety_inspections_id_seq', 1, false);


--
-- Name: fire_safety_maintenance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.fire_safety_maintenance_id_seq', 1, false);


--
-- Name: first_aid_kit_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.first_aid_kit_items_id_seq', 1, false);


--
-- Name: first_aid_kits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.first_aid_kits_id_seq', 1, false);


--
-- Name: food_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.food_categories_id_seq', 6, true);


--
-- Name: food_item_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.food_item_images_id_seq', 4, true);


--
-- Name: food_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.food_items_id_seq', 5, true);


--
-- Name: food_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.food_order_items_id_seq', 11, true);


--
-- Name: food_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.food_orders_id_seq', 10, true);


--
-- Name: gallery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.gallery_id_seq', 1, false);


--
-- Name: goods_received_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.goods_received_notes_id_seq', 1, false);


--
-- Name: grn_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.grn_items_id_seq', 1, false);


--
-- Name: guest_suggestions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.guest_suggestions_id_seq', 1, false);


--
-- Name: header_banner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.header_banner_id_seq', 1, false);


--
-- Name: indent_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.indent_items_id_seq', 1, false);


--
-- Name: indents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.indents_id_seq', 1, false);


--
-- Name: inventory_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.inventory_categories_id_seq', 11, true);


--
-- Name: inventory_expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.inventory_expenses_id_seq', 1, false);


--
-- Name: inventory_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.inventory_items_id_seq', 25, true);


--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.inventory_transactions_id_seq', 217, true);


--
-- Name: journal_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.journal_entries_id_seq', 1, false);


--
-- Name: journal_entry_lines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.journal_entry_lines_id_seq', 1, false);


--
-- Name: key_management_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.key_management_id_seq', 1, false);


--
-- Name: key_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.key_movements_id_seq', 1, false);


--
-- Name: laundry_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.laundry_logs_id_seq', 1, true);


--
-- Name: laundry_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.laundry_services_id_seq', 1, false);


--
-- Name: leaves_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.leaves_id_seq', 1, false);


--
-- Name: legal_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.legal_documents_id_seq', 1, false);


--
-- Name: linen_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.linen_items_id_seq', 1, false);


--
-- Name: linen_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.linen_movements_id_seq', 1, false);


--
-- Name: linen_stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.linen_stocks_id_seq', 1, false);


--
-- Name: linen_wash_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.linen_wash_logs_id_seq', 1, false);


--
-- Name: location_stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.location_stocks_id_seq', 162, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.locations_id_seq', 17, true);


--
-- Name: lost_found_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.lost_found_id_seq', 1, false);


--
-- Name: maintenance_tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.maintenance_tickets_id_seq', 1, false);


--
-- Name: nearby_attraction_banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.nearby_attraction_banners_id_seq', 1, false);


--
-- Name: nearby_attractions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.nearby_attractions_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.notifications_id_seq', 213, true);


--
-- Name: office_inventory_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.office_inventory_items_id_seq', 1, false);


--
-- Name: office_requisitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.office_requisitions_id_seq', 1, false);


--
-- Name: outlet_stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.outlet_stocks_id_seq', 1, false);


--
-- Name: outlets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.outlets_id_seq', 1, false);


--
-- Name: package_booking_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.package_booking_rooms_id_seq', 4, true);


--
-- Name: package_bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.package_bookings_id_seq', 4, true);


--
-- Name: package_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.package_images_id_seq', 23, true);


--
-- Name: packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.packages_id_seq', 20, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Name: perishable_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.perishable_batches_id_seq', 1, false);


--
-- Name: plan_weddings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.plan_weddings_id_seq', 1, false);


--
-- Name: po_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.po_items_id_seq', 1, false);


--
-- Name: purchase_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.purchase_details_id_seq', 36, true);


--
-- Name: purchase_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.purchase_entries_id_seq', 1, false);


--
-- Name: purchase_entry_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.purchase_entry_items_id_seq', 1, false);


--
-- Name: purchase_masters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.purchase_masters_id_seq', 25, true);


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.purchase_orders_id_seq', 1, false);


--
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.recipe_ingredients_id_seq', 15, true);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.recipes_id_seq', 6, true);


--
-- Name: resort_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.resort_info_id_seq', 1, false);


--
-- Name: restock_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.restock_alerts_id_seq', 1, false);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.roles_id_seq', 7, true);


--
-- Name: room_assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.room_assets_id_seq', 1, false);


--
-- Name: room_consumable_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.room_consumable_assignments_id_seq', 1, false);


--
-- Name: room_consumable_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.room_consumable_items_id_seq', 1, false);


--
-- Name: room_inventory_audits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.room_inventory_audits_id_seq', 1, false);


--
-- Name: room_inventory_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.room_inventory_items_id_seq', 1, false);


--
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.rooms_id_seq', 9, true);


--
-- Name: salary_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.salary_payments_id_seq', 1, false);


--
-- Name: security_equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.security_equipment_id_seq', 1, false);


--
-- Name: security_maintenance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.security_maintenance_id_seq', 1, false);


--
-- Name: security_uniforms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.security_uniforms_id_seq', 1, false);


--
-- Name: service_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.service_images_id_seq', 6, true);


--
-- Name: service_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.service_requests_id_seq', 38, true);


--
-- Name: services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.services_id_seq', 5, true);


--
-- Name: signature_experiences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.signature_experiences_id_seq', 1, false);


--
-- Name: stock_issue_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.stock_issue_details_id_seq', 44, true);


--
-- Name: stock_issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.stock_issues_id_seq', 35, true);


--
-- Name: stock_levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.stock_levels_id_seq', 1, false);


--
-- Name: stock_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.stock_movements_id_seq', 1, false);


--
-- Name: stock_requisition_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.stock_requisition_details_id_seq', 2, true);


--
-- Name: stock_requisitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.stock_requisitions_id_seq', 2, true);


--
-- Name: stock_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.stock_usage_id_seq', 1, false);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 9, true);


--
-- Name: units_of_measurement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.units_of_measurement_id_seq', 1, false);


--
-- Name: uom_conversions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.uom_conversions_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.users_id_seq', 55, true);


--
-- Name: vendor_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.vendor_items_id_seq', 1, false);


--
-- Name: vendor_performance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.vendor_performance_id_seq', 1, false);


--
-- Name: vendors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.vendors_id_seq', 12, true);


--
-- Name: vouchers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.vouchers_id_seq', 1, false);


--
-- Name: wastage_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.wastage_logs_id_seq', 1, false);


--
-- Name: waste_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.waste_logs_id_seq', 4, true);


--
-- Name: work_order_part_issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.work_order_part_issues_id_seq', 1, false);


--
-- Name: work_order_parts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.work_order_parts_id_seq', 1, false);


--
-- Name: work_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.work_orders_id_seq', 1, false);


--
-- Name: working_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: orchid_user
--

SELECT pg_catalog.setval('public.working_logs_id_seq', 1, false);


--
-- Name: account_groups account_groups_name_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.account_groups
    ADD CONSTRAINT account_groups_name_key UNIQUE (name);


--
-- Name: account_groups account_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.account_groups
    ADD CONSTRAINT account_groups_pkey PRIMARY KEY (id);


--
-- Name: account_ledgers account_ledgers_code_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.account_ledgers
    ADD CONSTRAINT account_ledgers_code_key UNIQUE (code);


--
-- Name: account_ledgers account_ledgers_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.account_ledgers
    ADD CONSTRAINT account_ledgers_pkey PRIMARY KEY (id);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: approval_matrices approval_matrices_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_matrices
    ADD CONSTRAINT approval_matrices_pkey PRIMARY KEY (id);


--
-- Name: approval_requests approval_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_pkey PRIMARY KEY (id);


--
-- Name: asset_inspections asset_inspections_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_inspections
    ADD CONSTRAINT asset_inspections_pkey PRIMARY KEY (id);


--
-- Name: asset_maintenance asset_maintenance_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_maintenance
    ADD CONSTRAINT asset_maintenance_pkey PRIMARY KEY (id);


--
-- Name: asset_mappings asset_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_pkey PRIMARY KEY (id);


--
-- Name: asset_registry asset_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_pkey PRIMARY KEY (id);


--
-- Name: assigned_services assigned_services_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_pkey PRIMARY KEY (id);


--
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: audit_discrepancies audit_discrepancies_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.audit_discrepancies
    ADD CONSTRAINT audit_discrepancies_pkey PRIMARY KEY (id);


--
-- Name: booking_rooms booking_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: check_availability check_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.check_availability
    ADD CONSTRAINT check_availability_pkey PRIMARY KEY (id);


--
-- Name: checklist_executions checklist_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_executions
    ADD CONSTRAINT checklist_executions_pkey PRIMARY KEY (id);


--
-- Name: checklist_items checklist_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_items
    ADD CONSTRAINT checklist_items_pkey PRIMARY KEY (id);


--
-- Name: checklist_responses checklist_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_responses
    ADD CONSTRAINT checklist_responses_pkey PRIMARY KEY (id);


--
-- Name: checklists checklists_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklists
    ADD CONSTRAINT checklists_pkey PRIMARY KEY (id);


--
-- Name: checkout_payments checkout_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_payments
    ADD CONSTRAINT checkout_payments_pkey PRIMARY KEY (id);


--
-- Name: checkout_requests checkout_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_pkey PRIMARY KEY (id);


--
-- Name: checkout_verifications checkout_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_verifications
    ADD CONSTRAINT checkout_verifications_pkey PRIMARY KEY (id);


--
-- Name: checkouts checkouts_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_booking_id_key UNIQUE (booking_id);


--
-- Name: checkouts checkouts_package_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_package_booking_id_key UNIQUE (package_booking_id);


--
-- Name: checkouts checkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_pkey PRIMARY KEY (id);


--
-- Name: consumable_usage consumable_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.consumable_usage
    ADD CONSTRAINT consumable_usage_pkey PRIMARY KEY (id);


--
-- Name: cost_centers cost_centers_code_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.cost_centers
    ADD CONSTRAINT cost_centers_code_key UNIQUE (code);


--
-- Name: cost_centers cost_centers_name_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.cost_centers
    ADD CONSTRAINT cost_centers_name_key UNIQUE (name);


--
-- Name: cost_centers cost_centers_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.cost_centers
    ADD CONSTRAINT cost_centers_pkey PRIMARY KEY (id);


--
-- Name: damage_reports damage_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.damage_reports
    ADD CONSTRAINT damage_reports_pkey PRIMARY KEY (id);


--
-- Name: employee_inventory_assignments employee_inventory_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: employees employees_user_id_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_key UNIQUE (user_id);


--
-- Name: eod_audit_items eod_audit_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.eod_audit_items
    ADD CONSTRAINT eod_audit_items_pkey PRIMARY KEY (id);


--
-- Name: eod_audits eod_audits_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.eod_audits
    ADD CONSTRAINT eod_audits_pkey PRIMARY KEY (id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: expiry_alerts expiry_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expiry_alerts
    ADD CONSTRAINT expiry_alerts_pkey PRIMARY KEY (id);


--
-- Name: fire_safety_equipment fire_safety_equipment_asset_id_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_equipment
    ADD CONSTRAINT fire_safety_equipment_asset_id_key UNIQUE (asset_id);


--
-- Name: fire_safety_equipment fire_safety_equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_equipment
    ADD CONSTRAINT fire_safety_equipment_pkey PRIMARY KEY (id);


--
-- Name: fire_safety_incidents fire_safety_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_incidents
    ADD CONSTRAINT fire_safety_incidents_pkey PRIMARY KEY (id);


--
-- Name: fire_safety_inspections fire_safety_inspections_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_inspections
    ADD CONSTRAINT fire_safety_inspections_pkey PRIMARY KEY (id);


--
-- Name: fire_safety_maintenance fire_safety_maintenance_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_maintenance
    ADD CONSTRAINT fire_safety_maintenance_pkey PRIMARY KEY (id);


--
-- Name: first_aid_kit_items first_aid_kit_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kit_items
    ADD CONSTRAINT first_aid_kit_items_pkey PRIMARY KEY (id);


--
-- Name: first_aid_kits first_aid_kits_kit_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kits
    ADD CONSTRAINT first_aid_kits_kit_number_key UNIQUE (kit_number);


--
-- Name: first_aid_kits first_aid_kits_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kits
    ADD CONSTRAINT first_aid_kits_pkey PRIMARY KEY (id);


--
-- Name: food_categories food_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_categories
    ADD CONSTRAINT food_categories_pkey PRIMARY KEY (id);


--
-- Name: food_item_images food_item_images_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_item_images
    ADD CONSTRAINT food_item_images_pkey PRIMARY KEY (id);


--
-- Name: food_items food_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_items
    ADD CONSTRAINT food_items_pkey PRIMARY KEY (id);


--
-- Name: food_order_items food_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_pkey PRIMARY KEY (id);


--
-- Name: food_orders food_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_pkey PRIMARY KEY (id);


--
-- Name: gallery gallery_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.gallery
    ADD CONSTRAINT gallery_pkey PRIMARY KEY (id);


--
-- Name: goods_received_notes goods_received_notes_grn_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.goods_received_notes
    ADD CONSTRAINT goods_received_notes_grn_number_key UNIQUE (grn_number);


--
-- Name: goods_received_notes goods_received_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.goods_received_notes
    ADD CONSTRAINT goods_received_notes_pkey PRIMARY KEY (id);


--
-- Name: grn_items grn_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_pkey PRIMARY KEY (id);


--
-- Name: guest_suggestions guest_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.guest_suggestions
    ADD CONSTRAINT guest_suggestions_pkey PRIMARY KEY (id);


--
-- Name: header_banner header_banner_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.header_banner
    ADD CONSTRAINT header_banner_pkey PRIMARY KEY (id);


--
-- Name: indent_items indent_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indent_items
    ADD CONSTRAINT indent_items_pkey PRIMARY KEY (id);


--
-- Name: indents indents_indent_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indents
    ADD CONSTRAINT indents_indent_number_key UNIQUE (indent_number);


--
-- Name: indents indents_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indents
    ADD CONSTRAINT indents_pkey PRIMARY KEY (id);


--
-- Name: inventory_categories inventory_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_categories
    ADD CONSTRAINT inventory_categories_name_key UNIQUE (name);


--
-- Name: inventory_categories inventory_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_categories
    ADD CONSTRAINT inventory_categories_pkey PRIMARY KEY (id);


--
-- Name: inventory_expenses inventory_expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_expenses
    ADD CONSTRAINT inventory_expenses_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_sku_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_sku_key UNIQUE (sku);


--
-- Name: inventory_transactions inventory_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_pkey PRIMARY KEY (id);


--
-- Name: journal_entries journal_entries_entry_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_entry_number_key UNIQUE (entry_number);


--
-- Name: journal_entries journal_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_pkey PRIMARY KEY (id);


--
-- Name: journal_entry_lines journal_entry_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_pkey PRIMARY KEY (id);


--
-- Name: key_management key_management_key_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_management
    ADD CONSTRAINT key_management_key_number_key UNIQUE (key_number);


--
-- Name: key_management key_management_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_management
    ADD CONSTRAINT key_management_pkey PRIMARY KEY (id);


--
-- Name: key_movements key_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_movements
    ADD CONSTRAINT key_movements_pkey PRIMARY KEY (id);


--
-- Name: laundry_logs laundry_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_pkey PRIMARY KEY (id);


--
-- Name: laundry_services laundry_services_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.laundry_services
    ADD CONSTRAINT laundry_services_pkey PRIMARY KEY (id);


--
-- Name: leaves leaves_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_pkey PRIMARY KEY (id);


--
-- Name: legal_documents legal_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.legal_documents
    ADD CONSTRAINT legal_documents_pkey PRIMARY KEY (id);


--
-- Name: linen_items linen_items_barcode_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_items
    ADD CONSTRAINT linen_items_barcode_key UNIQUE (barcode);


--
-- Name: linen_items linen_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_items
    ADD CONSTRAINT linen_items_pkey PRIMARY KEY (id);


--
-- Name: linen_items linen_items_rfid_tag_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_items
    ADD CONSTRAINT linen_items_rfid_tag_key UNIQUE (rfid_tag);


--
-- Name: linen_movements linen_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_movements
    ADD CONSTRAINT linen_movements_pkey PRIMARY KEY (id);


--
-- Name: linen_stocks linen_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_stocks
    ADD CONSTRAINT linen_stocks_pkey PRIMARY KEY (id);


--
-- Name: linen_wash_logs linen_wash_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_wash_logs
    ADD CONSTRAINT linen_wash_logs_pkey PRIMARY KEY (id);


--
-- Name: location_stocks location_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.location_stocks
    ADD CONSTRAINT location_stocks_pkey PRIMARY KEY (id);


--
-- Name: locations locations_code_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_code_key UNIQUE (code);


--
-- Name: locations locations_location_code_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_location_code_key UNIQUE (location_code);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: lost_found lost_found_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.lost_found
    ADD CONSTRAINT lost_found_pkey PRIMARY KEY (id);


--
-- Name: maintenance_tickets maintenance_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.maintenance_tickets
    ADD CONSTRAINT maintenance_tickets_pkey PRIMARY KEY (id);


--
-- Name: nearby_attraction_banners nearby_attraction_banners_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.nearby_attraction_banners
    ADD CONSTRAINT nearby_attraction_banners_pkey PRIMARY KEY (id);


--
-- Name: nearby_attractions nearby_attractions_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.nearby_attractions
    ADD CONSTRAINT nearby_attractions_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: office_inventory_items office_inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_inventory_items
    ADD CONSTRAINT office_inventory_items_pkey PRIMARY KEY (id);


--
-- Name: office_requisitions office_requisitions_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions
    ADD CONSTRAINT office_requisitions_pkey PRIMARY KEY (id);


--
-- Name: office_requisitions office_requisitions_req_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions
    ADD CONSTRAINT office_requisitions_req_number_key UNIQUE (req_number);


--
-- Name: outlet_stocks outlet_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlet_stocks
    ADD CONSTRAINT outlet_stocks_pkey PRIMARY KEY (id);


--
-- Name: outlets outlets_code_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlets
    ADD CONSTRAINT outlets_code_key UNIQUE (code);


--
-- Name: outlets outlets_name_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlets
    ADD CONSTRAINT outlets_name_key UNIQUE (name);


--
-- Name: outlets outlets_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlets
    ADD CONSTRAINT outlets_pkey PRIMARY KEY (id);


--
-- Name: package_booking_rooms package_booking_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_pkey PRIMARY KEY (id);


--
-- Name: package_bookings package_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_pkey PRIMARY KEY (id);


--
-- Name: package_images package_images_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_images
    ADD CONSTRAINT package_images_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: perishable_batches perishable_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.perishable_batches
    ADD CONSTRAINT perishable_batches_pkey PRIMARY KEY (id);


--
-- Name: plan_weddings plan_weddings_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.plan_weddings
    ADD CONSTRAINT plan_weddings_pkey PRIMARY KEY (id);


--
-- Name: po_items po_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.po_items
    ADD CONSTRAINT po_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_details purchase_details_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT purchase_details_pkey PRIMARY KEY (id);


--
-- Name: purchase_entries purchase_entries_entry_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entries
    ADD CONSTRAINT purchase_entries_entry_number_key UNIQUE (entry_number);


--
-- Name: purchase_entries purchase_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entries
    ADD CONSTRAINT purchase_entries_pkey PRIMARY KEY (id);


--
-- Name: purchase_entry_items purchase_entry_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entry_items
    ADD CONSTRAINT purchase_entry_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_masters purchase_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_masters
    ADD CONSTRAINT purchase_masters_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_po_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_po_number_key UNIQUE (po_number);


--
-- Name: recipe_ingredients recipe_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: resort_info resort_info_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.resort_info
    ADD CONSTRAINT resort_info_pkey PRIMARY KEY (id);


--
-- Name: restock_alerts restock_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.restock_alerts
    ADD CONSTRAINT restock_alerts_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: room_assets room_assets_asset_id_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_assets
    ADD CONSTRAINT room_assets_asset_id_key UNIQUE (asset_id);


--
-- Name: room_assets room_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_assets
    ADD CONSTRAINT room_assets_pkey PRIMARY KEY (id);


--
-- Name: room_consumable_assignments room_consumable_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_assignments
    ADD CONSTRAINT room_consumable_assignments_pkey PRIMARY KEY (id);


--
-- Name: room_consumable_items room_consumable_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_items
    ADD CONSTRAINT room_consumable_items_pkey PRIMARY KEY (id);


--
-- Name: room_inventory_audits room_inventory_audits_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_audits
    ADD CONSTRAINT room_inventory_audits_pkey PRIMARY KEY (id);


--
-- Name: room_inventory_items room_inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_items
    ADD CONSTRAINT room_inventory_items_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_number_key UNIQUE (number);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: salary_payments salary_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.salary_payments
    ADD CONSTRAINT salary_payments_pkey PRIMARY KEY (id);


--
-- Name: security_equipment security_equipment_asset_id_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_equipment
    ADD CONSTRAINT security_equipment_asset_id_key UNIQUE (asset_id);


--
-- Name: security_equipment security_equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_equipment
    ADD CONSTRAINT security_equipment_pkey PRIMARY KEY (id);


--
-- Name: security_maintenance security_maintenance_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_maintenance
    ADD CONSTRAINT security_maintenance_pkey PRIMARY KEY (id);


--
-- Name: security_uniforms security_uniforms_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_uniforms
    ADD CONSTRAINT security_uniforms_pkey PRIMARY KEY (id);


--
-- Name: service_images service_images_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_images
    ADD CONSTRAINT service_images_pkey PRIMARY KEY (id);


--
-- Name: service_inventory_items service_inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_inventory_items
    ADD CONSTRAINT service_inventory_items_pkey PRIMARY KEY (service_id, inventory_item_id);


--
-- Name: service_requests service_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: signature_experiences signature_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.signature_experiences
    ADD CONSTRAINT signature_experiences_pkey PRIMARY KEY (id);


--
-- Name: stock_issue_details stock_issue_details_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issue_details
    ADD CONSTRAINT stock_issue_details_pkey PRIMARY KEY (id);


--
-- Name: stock_issues stock_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_pkey PRIMARY KEY (id);


--
-- Name: stock_levels stock_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_levels
    ADD CONSTRAINT stock_levels_pkey PRIMARY KEY (id);


--
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- Name: stock_requisition_details stock_requisition_details_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_requisition_details
    ADD CONSTRAINT stock_requisition_details_pkey PRIMARY KEY (id);


--
-- Name: stock_requisitions stock_requisitions_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_requisitions
    ADD CONSTRAINT stock_requisitions_pkey PRIMARY KEY (id);


--
-- Name: stock_usage stock_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_usage
    ADD CONSTRAINT stock_usage_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: units_of_measurement units_of_measurement_name_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.units_of_measurement
    ADD CONSTRAINT units_of_measurement_name_key UNIQUE (name);


--
-- Name: units_of_measurement units_of_measurement_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.units_of_measurement
    ADD CONSTRAINT units_of_measurement_pkey PRIMARY KEY (id);


--
-- Name: uom_conversions uom_conversions_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.uom_conversions
    ADD CONSTRAINT uom_conversions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendor_items vendor_items_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendor_items
    ADD CONSTRAINT vendor_items_pkey PRIMARY KEY (id);


--
-- Name: vendor_performance vendor_performance_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendor_performance
    ADD CONSTRAINT vendor_performance_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_code_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_code_key UNIQUE (code);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (id);


--
-- Name: wastage_logs wastage_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.wastage_logs
    ADD CONSTRAINT wastage_logs_pkey PRIMARY KEY (id);


--
-- Name: waste_logs waste_logs_log_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_log_number_key UNIQUE (log_number);


--
-- Name: waste_logs waste_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_pkey PRIMARY KEY (id);


--
-- Name: work_order_part_issues work_order_part_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_part_issues
    ADD CONSTRAINT work_order_part_issues_pkey PRIMARY KEY (id);


--
-- Name: work_order_parts work_order_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_parts
    ADD CONSTRAINT work_order_parts_pkey PRIMARY KEY (id);


--
-- Name: work_orders work_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT work_orders_pkey PRIMARY KEY (id);


--
-- Name: work_orders work_orders_wo_number_key; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT work_orders_wo_number_key UNIQUE (wo_number);


--
-- Name: working_logs working_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.working_logs
    ADD CONSTRAINT working_logs_pkey PRIMARY KEY (id);


--
-- Name: idx_account_ledgers_group_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_account_ledgers_group_id ON public.account_ledgers USING btree (group_id);


--
-- Name: idx_booking_check_in; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_booking_check_in ON public.bookings USING btree (check_in);


--
-- Name: idx_booking_check_out; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_booking_check_out ON public.bookings USING btree (check_out);


--
-- Name: idx_booking_status; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_booking_status ON public.bookings USING btree (status);


--
-- Name: idx_checkout_booking_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_checkout_booking_id ON public.checkouts USING btree (booking_id);


--
-- Name: idx_checkout_date; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_checkout_date ON public.checkouts USING btree (checkout_date);


--
-- Name: idx_checkout_package_booking_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_checkout_package_booking_id ON public.checkouts USING btree (package_booking_id);


--
-- Name: idx_checkout_payments_checkout_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_checkout_payments_checkout_id ON public.checkout_payments USING btree (checkout_id);


--
-- Name: idx_checkout_room_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_checkout_room_number ON public.checkouts USING btree (room_number);


--
-- Name: idx_checkout_verifications_checkout_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_checkout_verifications_checkout_id ON public.checkout_verifications USING btree (checkout_id);


--
-- Name: idx_checkouts_invoice_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX idx_checkouts_invoice_number ON public.checkouts USING btree (invoice_number) WHERE (invoice_number IS NOT NULL);


--
-- Name: idx_expense_date; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_expense_date ON public.expenses USING btree (date);


--
-- Name: idx_expense_employee_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_expense_employee_id ON public.expenses USING btree (employee_id);


--
-- Name: idx_food_order_billing_status; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_food_order_billing_status ON public.food_orders USING btree (billing_status);


--
-- Name: idx_food_order_room_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_food_order_room_id ON public.food_orders USING btree (room_id);


--
-- Name: idx_food_order_status; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_food_order_status ON public.food_orders USING btree (status);


--
-- Name: idx_inventory_item_category_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_inventory_item_category_id ON public.inventory_items USING btree (category_id);


--
-- Name: idx_inventory_items_item_code; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_inventory_items_item_code ON public.inventory_items USING btree (item_code);


--
-- Name: idx_inventory_transaction_item_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_inventory_transaction_item_id ON public.inventory_transactions USING btree (item_id);


--
-- Name: idx_journal_entries_date; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entries_date ON public.journal_entries USING btree (entry_date);


--
-- Name: idx_journal_entries_reference; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entries_reference ON public.journal_entries USING btree (reference_type, reference_id);


--
-- Name: idx_journal_entry_date; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entry_date ON public.journal_entries USING btree (entry_date);


--
-- Name: idx_journal_entry_line_credit; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entry_line_credit ON public.journal_entry_lines USING btree (credit_ledger_id);


--
-- Name: idx_journal_entry_line_debit; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entry_line_debit ON public.journal_entry_lines USING btree (debit_ledger_id);


--
-- Name: idx_journal_entry_lines_credit; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entry_lines_credit ON public.journal_entry_lines USING btree (credit_ledger_id);


--
-- Name: idx_journal_entry_lines_debit; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entry_lines_debit ON public.journal_entry_lines USING btree (debit_ledger_id);


--
-- Name: idx_journal_entry_lines_entry_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entry_lines_entry_id ON public.journal_entry_lines USING btree (entry_id);


--
-- Name: idx_journal_entry_reference; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_journal_entry_reference ON public.journal_entries USING btree (reference_type, reference_id);


--
-- Name: idx_locations_location_code; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_locations_location_code ON public.locations USING btree (location_code);


--
-- Name: idx_purchase_vendor_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_purchase_vendor_id ON public.purchase_masters USING btree (vendor_id);


--
-- Name: idx_room_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_room_number ON public.rooms USING btree (number);


--
-- Name: idx_room_status; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_room_status ON public.rooms USING btree (status);


--
-- Name: idx_waste_logs_log_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX idx_waste_logs_log_number ON public.waste_logs USING btree (log_number);


--
-- Name: ix_account_groups_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_account_groups_id ON public.account_groups USING btree (id);


--
-- Name: ix_account_ledgers_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_account_ledgers_id ON public.account_ledgers USING btree (id);


--
-- Name: ix_activity_logs_action; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_activity_logs_action ON public.activity_logs USING btree (action);


--
-- Name: ix_activity_logs_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_activity_logs_id ON public.activity_logs USING btree (id);


--
-- Name: ix_approval_matrices_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_approval_matrices_id ON public.approval_matrices USING btree (id);


--
-- Name: ix_approval_requests_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_approval_requests_id ON public.approval_requests USING btree (id);


--
-- Name: ix_asset_inspections_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_asset_inspections_id ON public.asset_inspections USING btree (id);


--
-- Name: ix_asset_maintenance_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_asset_maintenance_id ON public.asset_maintenance USING btree (id);


--
-- Name: ix_asset_mappings_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_asset_mappings_id ON public.asset_mappings USING btree (id);


--
-- Name: ix_asset_registry_asset_tag_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX ix_asset_registry_asset_tag_id ON public.asset_registry USING btree (asset_tag_id);


--
-- Name: ix_asset_registry_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_asset_registry_id ON public.asset_registry USING btree (id);


--
-- Name: ix_assigned_services_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_assigned_services_id ON public.assigned_services USING btree (id);


--
-- Name: ix_attendances_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_attendances_id ON public.attendances USING btree (id);


--
-- Name: ix_audit_discrepancies_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_audit_discrepancies_id ON public.audit_discrepancies USING btree (id);


--
-- Name: ix_booking_rooms_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_booking_rooms_id ON public.booking_rooms USING btree (id);


--
-- Name: ix_bookings_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_bookings_id ON public.bookings USING btree (id);


--
-- Name: ix_check_availability_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_check_availability_id ON public.check_availability USING btree (id);


--
-- Name: ix_checklist_executions_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_checklist_executions_id ON public.checklist_executions USING btree (id);


--
-- Name: ix_checklist_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_checklist_items_id ON public.checklist_items USING btree (id);


--
-- Name: ix_checklist_responses_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_checklist_responses_id ON public.checklist_responses USING btree (id);


--
-- Name: ix_checklists_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_checklists_id ON public.checklists USING btree (id);


--
-- Name: ix_checkout_payments_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_checkout_payments_id ON public.checkout_payments USING btree (id);


--
-- Name: ix_checkout_requests_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_checkout_requests_id ON public.checkout_requests USING btree (id);


--
-- Name: ix_checkout_verifications_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_checkout_verifications_id ON public.checkout_verifications USING btree (id);


--
-- Name: ix_checkouts_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_checkouts_id ON public.checkouts USING btree (id);


--
-- Name: ix_consumable_usage_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_consumable_usage_id ON public.consumable_usage USING btree (id);


--
-- Name: ix_cost_centers_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_cost_centers_id ON public.cost_centers USING btree (id);


--
-- Name: ix_damage_reports_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_damage_reports_id ON public.damage_reports USING btree (id);


--
-- Name: ix_employee_inventory_assignments_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_employee_inventory_assignments_id ON public.employee_inventory_assignments USING btree (id);


--
-- Name: ix_employees_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_employees_id ON public.employees USING btree (id);


--
-- Name: ix_eod_audit_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_eod_audit_items_id ON public.eod_audit_items USING btree (id);


--
-- Name: ix_eod_audits_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_eod_audits_id ON public.eod_audits USING btree (id);


--
-- Name: ix_expenses_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_expenses_id ON public.expenses USING btree (id);


--
-- Name: ix_expenses_self_invoice_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX ix_expenses_self_invoice_number ON public.expenses USING btree (self_invoice_number);


--
-- Name: ix_expiry_alerts_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_expiry_alerts_id ON public.expiry_alerts USING btree (id);


--
-- Name: ix_fire_safety_equipment_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_fire_safety_equipment_id ON public.fire_safety_equipment USING btree (id);


--
-- Name: ix_fire_safety_incidents_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_fire_safety_incidents_id ON public.fire_safety_incidents USING btree (id);


--
-- Name: ix_fire_safety_inspections_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_fire_safety_inspections_id ON public.fire_safety_inspections USING btree (id);


--
-- Name: ix_fire_safety_maintenance_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_fire_safety_maintenance_id ON public.fire_safety_maintenance USING btree (id);


--
-- Name: ix_first_aid_kit_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_first_aid_kit_items_id ON public.first_aid_kit_items USING btree (id);


--
-- Name: ix_first_aid_kits_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_first_aid_kits_id ON public.first_aid_kits USING btree (id);


--
-- Name: ix_food_categories_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_food_categories_id ON public.food_categories USING btree (id);


--
-- Name: ix_food_item_images_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_food_item_images_id ON public.food_item_images USING btree (id);


--
-- Name: ix_food_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_food_items_id ON public.food_items USING btree (id);


--
-- Name: ix_food_order_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_food_order_items_id ON public.food_order_items USING btree (id);


--
-- Name: ix_food_orders_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_food_orders_id ON public.food_orders USING btree (id);


--
-- Name: ix_gallery_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_gallery_id ON public.gallery USING btree (id);


--
-- Name: ix_goods_received_notes_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_goods_received_notes_id ON public.goods_received_notes USING btree (id);


--
-- Name: ix_grn_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_grn_items_id ON public.grn_items USING btree (id);


--
-- Name: ix_guest_suggestions_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_guest_suggestions_id ON public.guest_suggestions USING btree (id);


--
-- Name: ix_header_banner_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_header_banner_id ON public.header_banner USING btree (id);


--
-- Name: ix_indent_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_indent_items_id ON public.indent_items USING btree (id);


--
-- Name: ix_indents_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_indents_id ON public.indents USING btree (id);


--
-- Name: ix_inventory_categories_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_inventory_categories_id ON public.inventory_categories USING btree (id);


--
-- Name: ix_inventory_expenses_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_inventory_expenses_id ON public.inventory_expenses USING btree (id);


--
-- Name: ix_inventory_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_inventory_items_id ON public.inventory_items USING btree (id);


--
-- Name: ix_inventory_transactions_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_inventory_transactions_id ON public.inventory_transactions USING btree (id);


--
-- Name: ix_journal_entries_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_journal_entries_id ON public.journal_entries USING btree (id);


--
-- Name: ix_journal_entry_lines_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_journal_entry_lines_id ON public.journal_entry_lines USING btree (id);


--
-- Name: ix_key_management_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_key_management_id ON public.key_management USING btree (id);


--
-- Name: ix_key_movements_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_key_movements_id ON public.key_movements USING btree (id);


--
-- Name: ix_laundry_logs_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_laundry_logs_id ON public.laundry_logs USING btree (id);


--
-- Name: ix_laundry_services_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_laundry_services_id ON public.laundry_services USING btree (id);


--
-- Name: ix_leaves_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_leaves_id ON public.leaves USING btree (id);


--
-- Name: ix_legal_documents_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_legal_documents_id ON public.legal_documents USING btree (id);


--
-- Name: ix_linen_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_linen_items_id ON public.linen_items USING btree (id);


--
-- Name: ix_linen_movements_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_linen_movements_id ON public.linen_movements USING btree (id);


--
-- Name: ix_linen_stocks_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_linen_stocks_id ON public.linen_stocks USING btree (id);


--
-- Name: ix_linen_wash_logs_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_linen_wash_logs_id ON public.linen_wash_logs USING btree (id);


--
-- Name: ix_location_stocks_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_location_stocks_id ON public.location_stocks USING btree (id);


--
-- Name: ix_locations_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_locations_id ON public.locations USING btree (id);


--
-- Name: ix_lost_found_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_lost_found_id ON public.lost_found USING btree (id);


--
-- Name: ix_maintenance_tickets_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_maintenance_tickets_id ON public.maintenance_tickets USING btree (id);


--
-- Name: ix_nearby_attraction_banners_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_nearby_attraction_banners_id ON public.nearby_attraction_banners USING btree (id);


--
-- Name: ix_nearby_attractions_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_nearby_attractions_id ON public.nearby_attractions USING btree (id);


--
-- Name: ix_notifications_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_notifications_id ON public.notifications USING btree (id);


--
-- Name: ix_office_inventory_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_office_inventory_items_id ON public.office_inventory_items USING btree (id);


--
-- Name: ix_office_requisitions_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_office_requisitions_id ON public.office_requisitions USING btree (id);


--
-- Name: ix_outlet_stocks_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_outlet_stocks_id ON public.outlet_stocks USING btree (id);


--
-- Name: ix_outlets_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_outlets_id ON public.outlets USING btree (id);


--
-- Name: ix_package_booking_rooms_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_package_booking_rooms_id ON public.package_booking_rooms USING btree (id);


--
-- Name: ix_package_bookings_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_package_bookings_id ON public.package_bookings USING btree (id);


--
-- Name: ix_package_images_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_package_images_id ON public.package_images USING btree (id);


--
-- Name: ix_packages_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_packages_id ON public.packages USING btree (id);


--
-- Name: ix_payments_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_payments_id ON public.payments USING btree (id);


--
-- Name: ix_perishable_batches_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_perishable_batches_id ON public.perishable_batches USING btree (id);


--
-- Name: ix_plan_weddings_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_plan_weddings_id ON public.plan_weddings USING btree (id);


--
-- Name: ix_po_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_po_items_id ON public.po_items USING btree (id);


--
-- Name: ix_purchase_details_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_purchase_details_id ON public.purchase_details USING btree (id);


--
-- Name: ix_purchase_entries_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_purchase_entries_id ON public.purchase_entries USING btree (id);


--
-- Name: ix_purchase_entry_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_purchase_entry_items_id ON public.purchase_entry_items USING btree (id);


--
-- Name: ix_purchase_masters_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_purchase_masters_id ON public.purchase_masters USING btree (id);


--
-- Name: ix_purchase_masters_invoice_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_purchase_masters_invoice_number ON public.purchase_masters USING btree (invoice_number);


--
-- Name: ix_purchase_masters_purchase_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX ix_purchase_masters_purchase_number ON public.purchase_masters USING btree (purchase_number);


--
-- Name: ix_purchase_orders_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_purchase_orders_id ON public.purchase_orders USING btree (id);


--
-- Name: ix_recipe_ingredients_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_recipe_ingredients_id ON public.recipe_ingredients USING btree (id);


--
-- Name: ix_recipes_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_recipes_id ON public.recipes USING btree (id);


--
-- Name: ix_resort_info_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_resort_info_id ON public.resort_info USING btree (id);


--
-- Name: ix_restock_alerts_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_restock_alerts_id ON public.restock_alerts USING btree (id);


--
-- Name: ix_reviews_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_reviews_id ON public.reviews USING btree (id);


--
-- Name: ix_roles_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_roles_id ON public.roles USING btree (id);


--
-- Name: ix_room_assets_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_room_assets_id ON public.room_assets USING btree (id);


--
-- Name: ix_room_consumable_assignments_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_room_consumable_assignments_id ON public.room_consumable_assignments USING btree (id);


--
-- Name: ix_room_consumable_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_room_consumable_items_id ON public.room_consumable_items USING btree (id);


--
-- Name: ix_room_inventory_audits_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_room_inventory_audits_id ON public.room_inventory_audits USING btree (id);


--
-- Name: ix_room_inventory_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_room_inventory_items_id ON public.room_inventory_items USING btree (id);


--
-- Name: ix_rooms_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_rooms_id ON public.rooms USING btree (id);


--
-- Name: ix_security_equipment_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_security_equipment_id ON public.security_equipment USING btree (id);


--
-- Name: ix_security_maintenance_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_security_maintenance_id ON public.security_maintenance USING btree (id);


--
-- Name: ix_security_uniforms_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_security_uniforms_id ON public.security_uniforms USING btree (id);


--
-- Name: ix_service_images_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_service_images_id ON public.service_images USING btree (id);


--
-- Name: ix_service_requests_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_service_requests_id ON public.service_requests USING btree (id);


--
-- Name: ix_services_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_services_id ON public.services USING btree (id);


--
-- Name: ix_signature_experiences_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_signature_experiences_id ON public.signature_experiences USING btree (id);


--
-- Name: ix_stock_issue_details_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_stock_issue_details_id ON public.stock_issue_details USING btree (id);


--
-- Name: ix_stock_issues_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_stock_issues_id ON public.stock_issues USING btree (id);


--
-- Name: ix_stock_issues_issue_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX ix_stock_issues_issue_number ON public.stock_issues USING btree (issue_number);


--
-- Name: ix_stock_levels_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_stock_levels_id ON public.stock_levels USING btree (id);


--
-- Name: ix_stock_movements_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_stock_movements_id ON public.stock_movements USING btree (id);


--
-- Name: ix_stock_requisition_details_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_stock_requisition_details_id ON public.stock_requisition_details USING btree (id);


--
-- Name: ix_stock_requisitions_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_stock_requisitions_id ON public.stock_requisitions USING btree (id);


--
-- Name: ix_stock_requisitions_requisition_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX ix_stock_requisitions_requisition_number ON public.stock_requisitions USING btree (requisition_number);


--
-- Name: ix_stock_usage_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_stock_usage_id ON public.stock_usage USING btree (id);


--
-- Name: ix_system_settings_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_system_settings_id ON public.system_settings USING btree (id);


--
-- Name: ix_system_settings_key; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX ix_system_settings_key ON public.system_settings USING btree (key);


--
-- Name: ix_units_of_measurement_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_units_of_measurement_id ON public.units_of_measurement USING btree (id);


--
-- Name: ix_uom_conversions_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_uom_conversions_id ON public.uom_conversions USING btree (id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_vendor_items_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_vendor_items_id ON public.vendor_items USING btree (id);


--
-- Name: ix_vendor_performance_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_vendor_performance_id ON public.vendor_performance USING btree (id);


--
-- Name: ix_vendors_gst_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE UNIQUE INDEX ix_vendors_gst_number ON public.vendors USING btree (gst_number);


--
-- Name: ix_vendors_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_vendors_id ON public.vendors USING btree (id);


--
-- Name: ix_vendors_name; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_vendors_name ON public.vendors USING btree (name);


--
-- Name: ix_vendors_pan_number; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_vendors_pan_number ON public.vendors USING btree (pan_number);


--
-- Name: ix_vouchers_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_vouchers_id ON public.vouchers USING btree (id);


--
-- Name: ix_wastage_logs_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_wastage_logs_id ON public.wastage_logs USING btree (id);


--
-- Name: ix_waste_logs_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_waste_logs_id ON public.waste_logs USING btree (id);


--
-- Name: ix_work_order_part_issues_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_work_order_part_issues_id ON public.work_order_part_issues USING btree (id);


--
-- Name: ix_work_order_parts_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_work_order_parts_id ON public.work_order_parts USING btree (id);


--
-- Name: ix_work_orders_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_work_orders_id ON public.work_orders USING btree (id);


--
-- Name: ix_working_logs_id; Type: INDEX; Schema: public; Owner: orchid_user
--

CREATE INDEX ix_working_logs_id ON public.working_logs USING btree (id);


--
-- Name: account_ledgers account_ledgers_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.account_ledgers
    ADD CONSTRAINT account_ledgers_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.account_groups(id);


--
-- Name: approval_matrices approval_matrices_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_matrices
    ADD CONSTRAINT approval_matrices_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.cost_centers(id);


--
-- Name: approval_requests approval_requests_level_1_approver_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_level_1_approver_fkey FOREIGN KEY (level_1_approver) REFERENCES public.users(id);


--
-- Name: approval_requests approval_requests_level_2_approver_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_level_2_approver_fkey FOREIGN KEY (level_2_approver) REFERENCES public.users(id);


--
-- Name: approval_requests approval_requests_level_3_approver_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_level_3_approver_fkey FOREIGN KEY (level_3_approver) REFERENCES public.users(id);


--
-- Name: approval_requests approval_requests_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- Name: asset_inspections asset_inspections_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_inspections
    ADD CONSTRAINT asset_inspections_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.room_assets(id);


--
-- Name: asset_inspections asset_inspections_inspected_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_inspections
    ADD CONSTRAINT asset_inspections_inspected_by_fkey FOREIGN KEY (inspected_by) REFERENCES public.users(id);


--
-- Name: asset_maintenance asset_maintenance_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_maintenance
    ADD CONSTRAINT asset_maintenance_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.room_assets(id);


--
-- Name: asset_maintenance asset_maintenance_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_maintenance
    ADD CONSTRAINT asset_maintenance_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: asset_mappings asset_mappings_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- Name: asset_mappings asset_mappings_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: asset_mappings asset_mappings_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_mappings
    ADD CONSTRAINT asset_mappings_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: asset_registry asset_registry_current_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_current_location_id_fkey FOREIGN KEY (current_location_id) REFERENCES public.locations(id);


--
-- Name: asset_registry asset_registry_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: asset_registry asset_registry_purchase_master_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.asset_registry
    ADD CONSTRAINT asset_registry_purchase_master_id_fkey FOREIGN KEY (purchase_master_id) REFERENCES public.purchase_masters(id);


--
-- Name: assigned_services assigned_services_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: assigned_services assigned_services_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: assigned_services assigned_services_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.assigned_services
    ADD CONSTRAINT assigned_services_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: attendances attendances_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: audit_discrepancies audit_discrepancies_audit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.audit_discrepancies
    ADD CONSTRAINT audit_discrepancies_audit_id_fkey FOREIGN KEY (audit_id) REFERENCES public.eod_audits(id);


--
-- Name: audit_discrepancies audit_discrepancies_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.audit_discrepancies
    ADD CONSTRAINT audit_discrepancies_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: audit_discrepancies audit_discrepancies_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.audit_discrepancies
    ADD CONSTRAINT audit_discrepancies_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: audit_discrepancies audit_discrepancies_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.audit_discrepancies
    ADD CONSTRAINT audit_discrepancies_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.users(id);


--
-- Name: booking_rooms booking_rooms_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: booking_rooms booking_rooms_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: checklist_executions checklist_executions_checklist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_executions
    ADD CONSTRAINT checklist_executions_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.checklists(id);


--
-- Name: checklist_executions checklist_executions_executed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_executions
    ADD CONSTRAINT checklist_executions_executed_by_fkey FOREIGN KEY (executed_by) REFERENCES public.users(id);


--
-- Name: checklist_executions checklist_executions_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_executions
    ADD CONSTRAINT checklist_executions_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: checklist_executions checklist_executions_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_executions
    ADD CONSTRAINT checklist_executions_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: checklist_items checklist_items_checklist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_items
    ADD CONSTRAINT checklist_items_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.checklists(id);


--
-- Name: checklist_responses checklist_responses_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_responses
    ADD CONSTRAINT checklist_responses_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.checklist_executions(id);


--
-- Name: checklist_responses checklist_responses_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_responses
    ADD CONSTRAINT checklist_responses_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.checklist_items(id);


--
-- Name: checklist_responses checklist_responses_responded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checklist_responses
    ADD CONSTRAINT checklist_responses_responded_by_fkey FOREIGN KEY (responded_by) REFERENCES public.users(id);


--
-- Name: checkout_payments checkout_payments_checkout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_payments
    ADD CONSTRAINT checkout_payments_checkout_id_fkey FOREIGN KEY (checkout_id) REFERENCES public.checkouts(id);


--
-- Name: checkout_requests checkout_requests_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: checkout_requests checkout_requests_checkout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_checkout_id_fkey FOREIGN KEY (checkout_id) REFERENCES public.checkouts(id);


--
-- Name: checkout_requests checkout_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: checkout_requests checkout_requests_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_requests
    ADD CONSTRAINT checkout_requests_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id);


--
-- Name: checkout_verifications checkout_verifications_checkout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_verifications
    ADD CONSTRAINT checkout_verifications_checkout_id_fkey FOREIGN KEY (checkout_id) REFERENCES public.checkouts(id);


--
-- Name: checkout_verifications checkout_verifications_checkout_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkout_verifications
    ADD CONSTRAINT checkout_verifications_checkout_request_id_fkey FOREIGN KEY (checkout_request_id) REFERENCES public.checkout_requests(id);


--
-- Name: checkouts checkouts_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: checkouts checkouts_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.checkouts
    ADD CONSTRAINT checkouts_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id);


--
-- Name: consumable_usage consumable_usage_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.consumable_usage
    ADD CONSTRAINT consumable_usage_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: consumable_usage consumable_usage_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.consumable_usage
    ADD CONSTRAINT consumable_usage_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: consumable_usage consumable_usage_recorded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.consumable_usage
    ADD CONSTRAINT consumable_usage_recorded_by_fkey FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- Name: consumable_usage consumable_usage_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.consumable_usage
    ADD CONSTRAINT consumable_usage_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: damage_reports damage_reports_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.damage_reports
    ADD CONSTRAINT damage_reports_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: damage_reports damage_reports_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.damage_reports
    ADD CONSTRAINT damage_reports_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: damage_reports damage_reports_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.damage_reports
    ADD CONSTRAINT damage_reports_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: damage_reports damage_reports_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.damage_reports
    ADD CONSTRAINT damage_reports_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.users(id);


--
-- Name: damage_reports damage_reports_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.damage_reports
    ADD CONSTRAINT damage_reports_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: employee_inventory_assignments employee_inventory_assignments_assigned_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_assigned_service_id_fkey FOREIGN KEY (assigned_service_id) REFERENCES public.assigned_services(id);


--
-- Name: employee_inventory_assignments employee_inventory_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: employee_inventory_assignments employee_inventory_assignments_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employee_inventory_assignments
    ADD CONSTRAINT employee_inventory_assignments_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: employees employees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: eod_audit_items eod_audit_items_audit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.eod_audit_items
    ADD CONSTRAINT eod_audit_items_audit_id_fkey FOREIGN KEY (audit_id) REFERENCES public.eod_audits(id);


--
-- Name: eod_audit_items eod_audit_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.eod_audit_items
    ADD CONSTRAINT eod_audit_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: eod_audits eod_audits_audited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.eod_audits
    ADD CONSTRAINT eod_audits_audited_by_fkey FOREIGN KEY (audited_by) REFERENCES public.users(id);


--
-- Name: eod_audits eod_audits_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.eod_audits
    ADD CONSTRAINT eod_audits_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: expenses expenses_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: expiry_alerts expiry_alerts_acknowledged_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expiry_alerts
    ADD CONSTRAINT expiry_alerts_acknowledged_by_fkey FOREIGN KEY (acknowledged_by) REFERENCES public.users(id);


--
-- Name: expiry_alerts expiry_alerts_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expiry_alerts
    ADD CONSTRAINT expiry_alerts_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: expiry_alerts expiry_alerts_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expiry_alerts
    ADD CONSTRAINT expiry_alerts_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: fire_safety_equipment fire_safety_equipment_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_equipment
    ADD CONSTRAINT fire_safety_equipment_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: fire_safety_equipment fire_safety_equipment_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_equipment
    ADD CONSTRAINT fire_safety_equipment_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: fire_safety_incidents fire_safety_incidents_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_incidents
    ADD CONSTRAINT fire_safety_incidents_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.fire_safety_equipment(id);


--
-- Name: fire_safety_incidents fire_safety_incidents_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_incidents
    ADD CONSTRAINT fire_safety_incidents_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: fire_safety_incidents fire_safety_incidents_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_incidents
    ADD CONSTRAINT fire_safety_incidents_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.users(id);


--
-- Name: fire_safety_inspections fire_safety_inspections_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_inspections
    ADD CONSTRAINT fire_safety_inspections_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.fire_safety_equipment(id);


--
-- Name: fire_safety_inspections fire_safety_inspections_inspected_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_inspections
    ADD CONSTRAINT fire_safety_inspections_inspected_by_fkey FOREIGN KEY (inspected_by) REFERENCES public.users(id);


--
-- Name: fire_safety_maintenance fire_safety_maintenance_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_maintenance
    ADD CONSTRAINT fire_safety_maintenance_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.fire_safety_equipment(id);


--
-- Name: fire_safety_maintenance fire_safety_maintenance_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.fire_safety_maintenance
    ADD CONSTRAINT fire_safety_maintenance_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: first_aid_kit_items first_aid_kit_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kit_items
    ADD CONSTRAINT first_aid_kit_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: first_aid_kit_items first_aid_kit_items_kit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kit_items
    ADD CONSTRAINT first_aid_kit_items_kit_id_fkey FOREIGN KEY (kit_id) REFERENCES public.first_aid_kits(id);


--
-- Name: first_aid_kits first_aid_kits_checked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kits
    ADD CONSTRAINT first_aid_kits_checked_by_fkey FOREIGN KEY (checked_by) REFERENCES public.users(id);


--
-- Name: first_aid_kits first_aid_kits_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.first_aid_kits
    ADD CONSTRAINT first_aid_kits_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: expenses fk_expenses_vendor_id; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT fk_expenses_vendor_id FOREIGN KEY (vendor_id) REFERENCES public.vendors(id) ON DELETE SET NULL;


--
-- Name: purchase_masters fk_purchase_masters_destination_location_id; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_masters
    ADD CONSTRAINT fk_purchase_masters_destination_location_id FOREIGN KEY (destination_location_id) REFERENCES public.locations(id);


--
-- Name: stock_issues fk_stock_issues_dest_location; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT fk_stock_issues_dest_location FOREIGN KEY (destination_location_id) REFERENCES public.locations(id);


--
-- Name: stock_issues fk_stock_issues_source_location; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT fk_stock_issues_source_location FOREIGN KEY (source_location_id) REFERENCES public.locations(id);


--
-- Name: waste_logs fk_waste_logs_food_item_id; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT fk_waste_logs_food_item_id FOREIGN KEY (food_item_id) REFERENCES public.food_items(id);


--
-- Name: waste_logs fk_waste_logs_location; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT fk_waste_logs_location FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: food_item_images food_item_images_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_item_images
    ADD CONSTRAINT food_item_images_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.food_items(id);


--
-- Name: food_items food_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_items
    ADD CONSTRAINT food_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.food_categories(id);


--
-- Name: food_order_items food_order_items_food_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_food_item_id_fkey FOREIGN KEY (food_item_id) REFERENCES public.food_items(id);


--
-- Name: food_order_items food_order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_order_items
    ADD CONSTRAINT food_order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.food_orders(id);


--
-- Name: food_orders food_orders_assigned_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_assigned_employee_id_fkey FOREIGN KEY (assigned_employee_id) REFERENCES public.employees(id);


--
-- Name: food_orders food_orders_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.employees(id);


--
-- Name: food_orders food_orders_prepared_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_prepared_by_id_fkey FOREIGN KEY (prepared_by_id) REFERENCES public.employees(id);


--
-- Name: food_orders food_orders_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.food_orders
    ADD CONSTRAINT food_orders_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: goods_received_notes goods_received_notes_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.goods_received_notes
    ADD CONSTRAINT goods_received_notes_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id);


--
-- Name: goods_received_notes goods_received_notes_received_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.goods_received_notes
    ADD CONSTRAINT goods_received_notes_received_by_fkey FOREIGN KEY (received_by) REFERENCES public.users(id);


--
-- Name: goods_received_notes goods_received_notes_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.goods_received_notes
    ADD CONSTRAINT goods_received_notes_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES public.users(id);


--
-- Name: grn_items grn_items_grn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_grn_id_fkey FOREIGN KEY (grn_id) REFERENCES public.goods_received_notes(id);


--
-- Name: grn_items grn_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: grn_items grn_items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: grn_items grn_items_po_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_po_item_id_fkey FOREIGN KEY (po_item_id) REFERENCES public.po_items(id);


--
-- Name: indent_items indent_items_indent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indent_items
    ADD CONSTRAINT indent_items_indent_id_fkey FOREIGN KEY (indent_id) REFERENCES public.indents(id);


--
-- Name: indent_items indent_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indent_items
    ADD CONSTRAINT indent_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: indents indents_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indents
    ADD CONSTRAINT indents_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: indents indents_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indents
    ADD CONSTRAINT indents_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- Name: indents indents_requested_from_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indents
    ADD CONSTRAINT indents_requested_from_location_id_fkey FOREIGN KEY (requested_from_location_id) REFERENCES public.locations(id);


--
-- Name: indents indents_requested_to_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.indents
    ADD CONSTRAINT indents_requested_to_location_id_fkey FOREIGN KEY (requested_to_location_id) REFERENCES public.locations(id);


--
-- Name: inventory_expenses inventory_expenses_cost_center_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_expenses
    ADD CONSTRAINT inventory_expenses_cost_center_id_fkey FOREIGN KEY (cost_center_id) REFERENCES public.cost_centers(id);


--
-- Name: inventory_expenses inventory_expenses_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_expenses
    ADD CONSTRAINT inventory_expenses_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: inventory_expenses inventory_expenses_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_expenses
    ADD CONSTRAINT inventory_expenses_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: inventory_items inventory_items_base_uom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_base_uom_id_fkey FOREIGN KEY (base_uom_id) REFERENCES public.units_of_measurement(id);


--
-- Name: inventory_items inventory_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.inventory_categories(id);


--
-- Name: inventory_transactions inventory_transactions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: inventory_transactions inventory_transactions_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: inventory_transactions inventory_transactions_purchase_master_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_purchase_master_id_fkey FOREIGN KEY (purchase_master_id) REFERENCES public.purchase_masters(id);


--
-- Name: journal_entries journal_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: journal_entries journal_entries_reversed_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_reversed_entry_id_fkey FOREIGN KEY (reversed_entry_id) REFERENCES public.journal_entries(id);


--
-- Name: journal_entry_lines journal_entry_lines_credit_ledger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_credit_ledger_id_fkey FOREIGN KEY (credit_ledger_id) REFERENCES public.account_ledgers(id);


--
-- Name: journal_entry_lines journal_entry_lines_debit_ledger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_debit_ledger_id_fkey FOREIGN KEY (debit_ledger_id) REFERENCES public.account_ledgers(id);


--
-- Name: journal_entry_lines journal_entry_lines_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.journal_entry_lines
    ADD CONSTRAINT journal_entry_lines_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES public.journal_entries(id);


--
-- Name: key_management key_management_current_holder_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_management
    ADD CONSTRAINT key_management_current_holder_fkey FOREIGN KEY (current_holder) REFERENCES public.users(id);


--
-- Name: key_management key_management_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_management
    ADD CONSTRAINT key_management_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: key_management key_management_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_management
    ADD CONSTRAINT key_management_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: key_movements key_movements_from_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_movements
    ADD CONSTRAINT key_movements_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(id);


--
-- Name: key_movements key_movements_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_movements
    ADD CONSTRAINT key_movements_key_id_fkey FOREIGN KEY (key_id) REFERENCES public.key_management(id);


--
-- Name: key_movements key_movements_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.key_movements
    ADD CONSTRAINT key_movements_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(id);


--
-- Name: laundry_logs laundry_logs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: laundry_logs laundry_logs_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: laundry_logs laundry_logs_source_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.laundry_logs
    ADD CONSTRAINT laundry_logs_source_location_id_fkey FOREIGN KEY (source_location_id) REFERENCES public.locations(id);


--
-- Name: laundry_services laundry_services_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.laundry_services
    ADD CONSTRAINT laundry_services_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: leaves leaves_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: linen_items linen_items_current_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_items
    ADD CONSTRAINT linen_items_current_location_id_fkey FOREIGN KEY (current_location_id) REFERENCES public.locations(id);


--
-- Name: linen_items linen_items_current_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_items
    ADD CONSTRAINT linen_items_current_room_id_fkey FOREIGN KEY (current_room_id) REFERENCES public.rooms(id);


--
-- Name: linen_items linen_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_items
    ADD CONSTRAINT linen_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: linen_movements linen_movements_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_movements
    ADD CONSTRAINT linen_movements_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: linen_movements linen_movements_moved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_movements
    ADD CONSTRAINT linen_movements_moved_by_fkey FOREIGN KEY (moved_by) REFERENCES public.users(id);


--
-- Name: linen_movements linen_movements_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_movements
    ADD CONSTRAINT linen_movements_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: linen_stocks linen_stocks_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_stocks
    ADD CONSTRAINT linen_stocks_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: linen_stocks linen_stocks_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_stocks
    ADD CONSTRAINT linen_stocks_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: linen_wash_logs linen_wash_logs_linen_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.linen_wash_logs
    ADD CONSTRAINT linen_wash_logs_linen_item_id_fkey FOREIGN KEY (linen_item_id) REFERENCES public.linen_items(id);


--
-- Name: location_stocks location_stocks_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.location_stocks
    ADD CONSTRAINT location_stocks_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: location_stocks location_stocks_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.location_stocks
    ADD CONSTRAINT location_stocks_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: locations locations_parent_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_parent_location_id_fkey FOREIGN KEY (parent_location_id) REFERENCES public.locations(id);


--
-- Name: lost_found lost_found_found_by_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.lost_found
    ADD CONSTRAINT lost_found_found_by_employee_id_fkey FOREIGN KEY (found_by_employee_id) REFERENCES public.employees(id);


--
-- Name: maintenance_tickets maintenance_tickets_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.maintenance_tickets
    ADD CONSTRAINT maintenance_tickets_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: maintenance_tickets maintenance_tickets_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.maintenance_tickets
    ADD CONSTRAINT maintenance_tickets_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: maintenance_tickets maintenance_tickets_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.maintenance_tickets
    ADD CONSTRAINT maintenance_tickets_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: maintenance_tickets maintenance_tickets_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.maintenance_tickets
    ADD CONSTRAINT maintenance_tickets_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.users(id);


--
-- Name: maintenance_tickets maintenance_tickets_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.maintenance_tickets
    ADD CONSTRAINT maintenance_tickets_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: notifications notifications_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.users(id);


--
-- Name: office_inventory_items office_inventory_items_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_inventory_items
    ADD CONSTRAINT office_inventory_items_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: office_inventory_items office_inventory_items_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_inventory_items
    ADD CONSTRAINT office_inventory_items_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.cost_centers(id);


--
-- Name: office_inventory_items office_inventory_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_inventory_items
    ADD CONSTRAINT office_inventory_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: office_inventory_items office_inventory_items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_inventory_items
    ADD CONSTRAINT office_inventory_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: office_requisitions office_requisitions_admin_approval_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions
    ADD CONSTRAINT office_requisitions_admin_approval_fkey FOREIGN KEY (admin_approval) REFERENCES public.users(id);


--
-- Name: office_requisitions office_requisitions_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions
    ADD CONSTRAINT office_requisitions_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.cost_centers(id);


--
-- Name: office_requisitions office_requisitions_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions
    ADD CONSTRAINT office_requisitions_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: office_requisitions office_requisitions_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions
    ADD CONSTRAINT office_requisitions_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.office_inventory_items(id);


--
-- Name: office_requisitions office_requisitions_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions
    ADD CONSTRAINT office_requisitions_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- Name: office_requisitions office_requisitions_supervisor_approval_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.office_requisitions
    ADD CONSTRAINT office_requisitions_supervisor_approval_fkey FOREIGN KEY (supervisor_approval) REFERENCES public.users(id);


--
-- Name: outlet_stocks outlet_stocks_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlet_stocks
    ADD CONSTRAINT outlet_stocks_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: outlet_stocks outlet_stocks_outlet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlet_stocks
    ADD CONSTRAINT outlet_stocks_outlet_id_fkey FOREIGN KEY (outlet_id) REFERENCES public.outlets(id);


--
-- Name: outlets outlets_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.outlets
    ADD CONSTRAINT outlets_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: package_booking_rooms package_booking_rooms_package_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_package_booking_id_fkey FOREIGN KEY (package_booking_id) REFERENCES public.package_bookings(id) ON DELETE CASCADE;


--
-- Name: package_booking_rooms package_booking_rooms_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_booking_rooms
    ADD CONSTRAINT package_booking_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: package_bookings package_bookings_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id);


--
-- Name: package_bookings package_bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_bookings
    ADD CONSTRAINT package_bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: package_images package_images_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.package_images
    ADD CONSTRAINT package_images_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id);


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: perishable_batches perishable_batches_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.perishable_batches
    ADD CONSTRAINT perishable_batches_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: perishable_batches perishable_batches_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.perishable_batches
    ADD CONSTRAINT perishable_batches_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: po_items po_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.po_items
    ADD CONSTRAINT po_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: po_items po_items_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.po_items
    ADD CONSTRAINT po_items_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id);


--
-- Name: purchase_details purchase_details_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT purchase_details_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: purchase_details purchase_details_purchase_master_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_details
    ADD CONSTRAINT purchase_details_purchase_master_id_fkey FOREIGN KEY (purchase_master_id) REFERENCES public.purchase_masters(id);


--
-- Name: purchase_entries purchase_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entries
    ADD CONSTRAINT purchase_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: purchase_entries purchase_entries_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entries
    ADD CONSTRAINT purchase_entries_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: purchase_entries purchase_entries_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entries
    ADD CONSTRAINT purchase_entries_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: purchase_entry_items purchase_entry_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entry_items
    ADD CONSTRAINT purchase_entry_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: purchase_entry_items purchase_entry_items_purchase_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entry_items
    ADD CONSTRAINT purchase_entry_items_purchase_entry_id_fkey FOREIGN KEY (purchase_entry_id) REFERENCES public.purchase_entries(id);


--
-- Name: purchase_entry_items purchase_entry_items_stock_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_entry_items
    ADD CONSTRAINT purchase_entry_items_stock_level_id_fkey FOREIGN KEY (stock_level_id) REFERENCES public.stock_levels(id);


--
-- Name: purchase_masters purchase_masters_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_masters
    ADD CONSTRAINT purchase_masters_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: purchase_orders purchase_orders_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: purchase_orders purchase_orders_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: purchase_orders purchase_orders_indent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_indent_id_fkey FOREIGN KEY (indent_id) REFERENCES public.indents(id);


--
-- Name: recipe_ingredients recipe_ingredients_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: recipe_ingredients recipe_ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id);


--
-- Name: recipes recipes_food_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_food_item_id_fkey FOREIGN KEY (food_item_id) REFERENCES public.food_items(id);


--
-- Name: restock_alerts restock_alerts_acknowledged_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.restock_alerts
    ADD CONSTRAINT restock_alerts_acknowledged_by_fkey FOREIGN KEY (acknowledged_by) REFERENCES public.users(id);


--
-- Name: restock_alerts restock_alerts_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.restock_alerts
    ADD CONSTRAINT restock_alerts_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: restock_alerts restock_alerts_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.restock_alerts
    ADD CONSTRAINT restock_alerts_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: restock_alerts restock_alerts_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.restock_alerts
    ADD CONSTRAINT restock_alerts_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.users(id);


--
-- Name: room_assets room_assets_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_assets
    ADD CONSTRAINT room_assets_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: room_assets room_assets_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_assets
    ADD CONSTRAINT room_assets_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: room_consumable_assignments room_consumable_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_assignments
    ADD CONSTRAINT room_consumable_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- Name: room_consumable_assignments room_consumable_assignments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_assignments
    ADD CONSTRAINT room_consumable_assignments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: room_consumable_assignments room_consumable_assignments_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_assignments
    ADD CONSTRAINT room_consumable_assignments_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: room_consumable_items room_consumable_items_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_items
    ADD CONSTRAINT room_consumable_items_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.room_consumable_assignments(id);


--
-- Name: room_consumable_items room_consumable_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_consumable_items
    ADD CONSTRAINT room_consumable_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: room_inventory_audits room_inventory_audits_audited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_audits
    ADD CONSTRAINT room_inventory_audits_audited_by_fkey FOREIGN KEY (audited_by) REFERENCES public.users(id);


--
-- Name: room_inventory_audits room_inventory_audits_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_audits
    ADD CONSTRAINT room_inventory_audits_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: room_inventory_audits room_inventory_audits_room_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_audits
    ADD CONSTRAINT room_inventory_audits_room_inventory_item_id_fkey FOREIGN KEY (room_inventory_item_id) REFERENCES public.room_inventory_items(id);


--
-- Name: room_inventory_items room_inventory_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_items
    ADD CONSTRAINT room_inventory_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: room_inventory_items room_inventory_items_last_audited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_items
    ADD CONSTRAINT room_inventory_items_last_audited_by_fkey FOREIGN KEY (last_audited_by) REFERENCES public.users(id);


--
-- Name: room_inventory_items room_inventory_items_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.room_inventory_items
    ADD CONSTRAINT room_inventory_items_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: rooms rooms_inventory_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_inventory_location_id_fkey FOREIGN KEY (inventory_location_id) REFERENCES public.locations(id);


--
-- Name: salary_payments salary_payments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.salary_payments
    ADD CONSTRAINT salary_payments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: security_equipment security_equipment_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_equipment
    ADD CONSTRAINT security_equipment_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: security_equipment security_equipment_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_equipment
    ADD CONSTRAINT security_equipment_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: security_equipment security_equipment_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_equipment
    ADD CONSTRAINT security_equipment_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: security_maintenance security_maintenance_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_maintenance
    ADD CONSTRAINT security_maintenance_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES public.security_equipment(id);


--
-- Name: security_maintenance security_maintenance_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_maintenance
    ADD CONSTRAINT security_maintenance_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: security_uniforms security_uniforms_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_uniforms
    ADD CONSTRAINT security_uniforms_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.users(id);


--
-- Name: security_uniforms security_uniforms_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.security_uniforms
    ADD CONSTRAINT security_uniforms_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: service_images service_images_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_images
    ADD CONSTRAINT service_images_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: service_inventory_items service_inventory_items_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_inventory_items
    ADD CONSTRAINT service_inventory_items_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: service_inventory_items service_inventory_items_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_inventory_items
    ADD CONSTRAINT service_inventory_items_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: service_requests service_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: service_requests service_requests_food_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_food_order_id_fkey FOREIGN KEY (food_order_id) REFERENCES public.food_orders(id);


--
-- Name: service_requests service_requests_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.service_requests
    ADD CONSTRAINT service_requests_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: stock_issue_details stock_issue_details_issue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issue_details
    ADD CONSTRAINT stock_issue_details_issue_id_fkey FOREIGN KEY (issue_id) REFERENCES public.stock_issues(id);


--
-- Name: stock_issue_details stock_issue_details_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issue_details
    ADD CONSTRAINT stock_issue_details_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: stock_issues stock_issues_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: stock_issues stock_issues_requisition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_issues
    ADD CONSTRAINT stock_issues_requisition_id_fkey FOREIGN KEY (requisition_id) REFERENCES public.stock_requisitions(id);


--
-- Name: stock_levels stock_levels_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_levels
    ADD CONSTRAINT stock_levels_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: stock_levels stock_levels_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_levels
    ADD CONSTRAINT stock_levels_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: stock_movements stock_movements_from_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_from_location_id_fkey FOREIGN KEY (from_location_id) REFERENCES public.locations(id);


--
-- Name: stock_movements stock_movements_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: stock_movements stock_movements_moved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_moved_by_fkey FOREIGN KEY (moved_by) REFERENCES public.users(id);


--
-- Name: stock_movements stock_movements_to_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_to_location_id_fkey FOREIGN KEY (to_location_id) REFERENCES public.locations(id);


--
-- Name: stock_requisition_details stock_requisition_details_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_requisition_details
    ADD CONSTRAINT stock_requisition_details_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: stock_requisition_details stock_requisition_details_requisition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_requisition_details
    ADD CONSTRAINT stock_requisition_details_requisition_id_fkey FOREIGN KEY (requisition_id) REFERENCES public.stock_requisitions(id);


--
-- Name: stock_requisitions stock_requisitions_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_requisitions
    ADD CONSTRAINT stock_requisitions_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: stock_requisitions stock_requisitions_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_requisitions
    ADD CONSTRAINT stock_requisitions_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- Name: stock_usage stock_usage_food_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_usage
    ADD CONSTRAINT stock_usage_food_order_id_fkey FOREIGN KEY (food_order_id) REFERENCES public.food_orders(id);


--
-- Name: stock_usage stock_usage_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_usage
    ADD CONSTRAINT stock_usage_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: stock_usage stock_usage_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_usage
    ADD CONSTRAINT stock_usage_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: stock_usage stock_usage_used_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.stock_usage
    ADD CONSTRAINT stock_usage_used_by_fkey FOREIGN KEY (used_by) REFERENCES public.users(id);


--
-- Name: uom_conversions uom_conversions_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.uom_conversions
    ADD CONSTRAINT uom_conversions_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: vendor_items vendor_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendor_items
    ADD CONSTRAINT vendor_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: vendor_items vendor_items_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendor_items
    ADD CONSTRAINT vendor_items_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: vendor_performance vendor_performance_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.vendor_performance
    ADD CONSTRAINT vendor_performance_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: wastage_logs wastage_logs_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.wastage_logs
    ADD CONSTRAINT wastage_logs_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: wastage_logs wastage_logs_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.wastage_logs
    ADD CONSTRAINT wastage_logs_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: wastage_logs wastage_logs_logged_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.wastage_logs
    ADD CONSTRAINT wastage_logs_logged_by_fkey FOREIGN KEY (logged_by) REFERENCES public.users(id);


--
-- Name: waste_logs waste_logs_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: waste_logs waste_logs_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.waste_logs
    ADD CONSTRAINT waste_logs_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.users(id);


--
-- Name: work_order_part_issues work_order_part_issues_from_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_part_issues
    ADD CONSTRAINT work_order_part_issues_from_location_id_fkey FOREIGN KEY (from_location_id) REFERENCES public.locations(id);


--
-- Name: work_order_part_issues work_order_part_issues_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_part_issues
    ADD CONSTRAINT work_order_part_issues_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: work_order_part_issues work_order_part_issues_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_part_issues
    ADD CONSTRAINT work_order_part_issues_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: work_order_part_issues work_order_part_issues_work_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_part_issues
    ADD CONSTRAINT work_order_part_issues_work_order_id_fkey FOREIGN KEY (work_order_id) REFERENCES public.work_orders(id);


--
-- Name: work_order_parts work_order_parts_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_parts
    ADD CONSTRAINT work_order_parts_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id);


--
-- Name: work_order_parts work_order_parts_work_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_order_parts
    ADD CONSTRAINT work_order_parts_work_order_id_fkey FOREIGN KEY (work_order_id) REFERENCES public.work_orders(id);


--
-- Name: work_orders work_orders_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT work_orders_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.room_assets(id);


--
-- Name: work_orders work_orders_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT work_orders_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: work_orders work_orders_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT work_orders_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: work_orders work_orders_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT work_orders_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.users(id);


--
-- Name: working_logs working_logs_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: orchid_user
--

ALTER TABLE ONLY public.working_logs
    ADD CONSTRAINT working_logs_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- PostgreSQL database dump complete
--

\unrestrict TXYaMvTHZhqlrg7wJaCmQ4JvCzuV8wG0bekDT8HCCUaUJGSmLoqyjWmpHzqtU1A

