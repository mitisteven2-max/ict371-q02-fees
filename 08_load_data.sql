-- ICT371 Q2 (a): six valid payments through the procedure (trigger already installed)
-- Chileshe: 3 payments (balance 2000)   Mutale: 3 payments (fully settled)
-- Natasha: no payments yet (owes the full 4000)
CALL pr_receive_payment(1, 1000, DATE '2026-11-03');
CALL pr_receive_payment(1, 1500, DATE '2026-11-10');
CALL pr_receive_payment(1,  500, DATE '2026-11-17');
CALL pr_receive_payment(2, 1000, DATE '2026-11-04');
CALL pr_receive_payment(2, 1000, DATE '2026-11-11');
CALL pr_receive_payment(2, 1000, DATE '2026-11-18');
