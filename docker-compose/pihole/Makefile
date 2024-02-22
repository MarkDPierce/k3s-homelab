.PHONY: compose down kill update update-pihole

kill:
	docker stop pihole && docker rm pihole

update-pihole:
	docker pull pihole/pihole

update:	update-pihole
update: kill
update: compose profile=pihole

include ../build.mk