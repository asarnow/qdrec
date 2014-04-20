delete from parasite_train_state where \
parasite_id in (select id from parasite where image_id in (select id from image where dataset_id = 13));

delete from parasite where \
image_id in (select id from image where dataset_id = 13);

update image set control_id = null where dataset_id = 13;
delete from image where dataset_id = 13;

delete from subset_position where \
subset_id in (select id from subset where dataset_id = 13);

delete from subset_image where \
subset_id in (select id from subset where dataset_id = 13);

delete from subset where dataset_id = 13;

delete from dataset where id = 13;
