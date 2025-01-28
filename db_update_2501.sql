\connect puget_sound_obsdata

ALTER TABLE ONLY obsdata.observations
    DROP CONSTRAINT date_depth_param_loc_uniq;

ALTER TABLE ONLY obsdata.observations
    ADD CONSTRAINT date_depth_param_loc_cast_uniq UNIQUE (datetime, depth, parameter_id, location_id, cast_id);

