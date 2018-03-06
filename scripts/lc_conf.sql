DELETE	FROM lc_transition_lnk_event
WHERE	event_id = 6
AND	transition_id = 7;

DELETE	FROM lc_action_set_lnk_action
WHERE	action_set_id = 9;

INSERT	INTO lc_action_set_lnk_action VALUES (9, 4, 1);
INSERT	INTO lc_action_set_lnk_action VALUES (9, 3, 2);
INSERT	INTO lc_action_set_lnk_action VALUES (9, 10, 3);

COMMIT;
