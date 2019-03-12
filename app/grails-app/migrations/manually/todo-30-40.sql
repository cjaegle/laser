﻿
-- erms-1074
-- 2019-03-11
-- clean up data / local dev environment only
UPDATE combo SET combo_type_rv_fk = (
  SELECT rdv.rdv_id from refdata_value rdv join refdata_category rdc on rdv.rdv_owner = rdc.rdc_id where rdv.rdv_value = 'Consortium' and rdc.rdc_description = 'Combo Type'
)
where combo_type_rv_fk = (
  SELECT rdv.rdv_id from refdata_value rdv join refdata_category rdc on rdv.rdv_owner = rdc.rdc_id where rdv.rdv_value = 'Consortium' and rdc.rdc_description = 'OrgType'
);

