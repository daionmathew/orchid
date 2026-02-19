-- Rename existing revenue ledgers
UPDATE account_ledgers SET name='Room Revenue (Taxable)' WHERE name='Room Revenue';
UPDATE account_ledgers SET name='Food Revenue (Taxable)' WHERE name='Food & Beverage Revenue';
UPDATE account_ledgers SET name='Service Revenue (Taxable)' WHERE name='Service Revenue';

-- Insert Package Revenue if missing
DO $$
DECLARE
    rev_group_id INTEGER;
BEGIN
    SELECT id INTO rev_group_id FROM account_groups WHERE name='Revenue Accounts';
    IF rev_group_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM account_ledgers WHERE name='Package Revenue (Taxable)') THEN
            INSERT INTO account_ledgers (name, group_id, module, is_active, balance_type)
            VALUES ('Package Revenue (Taxable)', rev_group_id, 'Booking', true, 'credit');
        END IF;
    END IF;
END $$;

-- Insert Output GST Ledgers if missing
DO $$
DECLARE
    tax_group_id INTEGER;
BEGIN
    SELECT id INTO tax_group_id FROM account_groups WHERE name='Duties & Taxes';
    IF tax_group_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM account_ledgers WHERE name='Output CGST') THEN
            INSERT INTO account_ledgers (name, group_id, module, is_active, balance_type, tax_type)
            VALUES ('Output CGST', tax_group_id, 'Tax', true, 'credit', 'Output');
        END IF;
        IF NOT EXISTS (SELECT 1 FROM account_ledgers WHERE name='Output SGST') THEN
            INSERT INTO account_ledgers (name, group_id, module, is_active, balance_type, tax_type)
            VALUES ('Output SGST', tax_group_id, 'Tax', true, 'credit', 'Output');
        END IF;
        IF NOT EXISTS (SELECT 1 FROM account_ledgers WHERE name='Output IGST') THEN
            INSERT INTO account_ledgers (name, group_id, module, is_active, balance_type, tax_type)
            VALUES ('Output IGST', tax_group_id, 'Tax', true, 'credit', 'Output');
        END IF;
    END IF;
END $$;
