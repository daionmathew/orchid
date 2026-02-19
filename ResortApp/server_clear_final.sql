
-- COMPREHENSIVE SERVER DATA CLEANUP
-- Targets orchid_resort database
-- Clears all transactional/operational data while preserving master data

SET session_replication_role = 'replica';

DO $$ 
DECLARE
    t text;
    tables_to_clear text[] := ARRAY[
        'activity_logs', 'bookings', 'booking_rooms', 'package_bookings', 
        'package_booking_rooms', 'checkouts', 'checkout_payments', 
        'checkout_verifications', 'checkout_requests', 'service_requests', 
        'food_orders', 'food_order_items', 'inventory_transactions', 
        'stock_issues', 'stock_issue_details', 'stock_requisitions', 
        'stock_requisition_details', 'stock_movements', 'stock_usage', 
        'stock_levels', 'location_stocks', 'outlet_stocks', 'linen_stocks', 
        'purchase_masters', 'purchase_details', 'purchase_orders', 'po_items', 
        'purchase_entries', 'purchase_entry_items', 'goods_received_notes', 
        'grn_items', 'wastage_logs', 'waste_logs', 'expenses', 
        'inventory_expenses', 'notifications', 'working_logs', 
        'maintenance_tickets', 'work_orders', 'work_order_parts', 
        'work_order_part_issues', 'lost_found', 'laundry_services', 
        'linen_movements', 'linen_wash_logs', 'room_consumable_assignments', 
        'room_inventory_audits', 'journal_entries', 'journal_entry_lines', 
        'vouchers', 'payments', 'key_movements', 'guest_suggestions', 
        'fire_safety_incidents', 'fire_safety_inspections', 
        'fire_safety_maintenance', 'security_maintenance', 
        'security_uniforms', 'restock_alerts', 'expiry_alerts', 
        'eod_audits', 'eod_audit_items', 'perishable_batches', 
        'indent_items', 'indents', 'accounting_ledgers', 
        'assigned_services', 'employee_inventory_assignments', 
        'leaves', 'attendances', 'salary_payments'
    ];
BEGIN
    FOREACH t IN ARRAY tables_to_clear LOOP
        EXECUTE format('TRUNCATE TABLE %I RESTART IDENTITY CASCADE', t);
        RAISE NOTICE 'Cleared table %', t;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Skipped table % (likely does not exist)', t;
    END LOOP;
END $$;

-- Reset Master Data Statuses
UPDATE rooms SET status = 'Available', housekeeping_status = 'Clean', housekeeping_updated_at = NULL;
UPDATE inventory_items SET current_stock = 0.0;

SET session_replication_role = 'origin';
