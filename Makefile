
PACKNAME = BucePack
PACKDIR  = $(PACKNAME)
SRCDIR   = pack
MCDIR    = $(HOME)/.minecraft
MCJAR    = $(MCDIR)/bin/minecraft.jar

# needed by all texture pack targets
DEFAULT = $(PACKDIR)/pack.mcmeta $(PACKDIR)/pack.png

# textures taken directly from previous versions of minecraft
NOSTALGIA = \
	$(PACKDIR)/assets/minecraft/textures/blocks/iron_block.png \
	$(PACKDIR)/assets/minecraft/textures/blocks/gravel.png \
	$(PACKDIR)/assets/minecraft/textures/items/apple.png \
	$(PACKDIR)/assets/minecraft/textures/items/chicken_raw.png \
	$(PACKDIR)/assets/minecraft/textures/items/chicken_cooked.png \
	$(PACKDIR)/assets/minecraft/textures/items/porkchop_cooked.png \
	$(PACKDIR)/assets/minecraft/textures/items/porkchop_raw.png \
	$(PACKDIR)/assets/minecraft/textures/items/beef_cooked.png \
	$(PACKDIR)/assets/minecraft/textures/items/beef_raw.png \
	$(PACKDIR)/assets/minecraft/textures/items/bread.png

# new textures that add flavor
FLAVOR = \
	$(PACKDIR)/assets/minecraft/textures/blocks/coal_ore.png \
	$(PACKDIR)/assets/minecraft/textures/blocks/lapis_ore.png \
	$(PACKDIR)/assets/minecraft/textures/blocks/diamond_ore.png \
	$(PACKDIR)/assets/minecraft/textures/blocks/redstone_ore.png \
	$(PACKDIR)/assets/minecraft/textures/items/emerald.png \
	$(PACKDIR)/assets/minecraft/textures/blocks/command_block.png \
	$(PACKDIR)/assets/minecraft/textures/items/fish_cooked.png \
	$(PACKDIR)/assets/minecraft/textures/items/fish_raw.png \
	$(PACKDIR)/assets/minecraft/textures/items/pumpkin_pie.png \
	$(PACKDIR)/assets/minecraft/textures/entity/iron_golem.png \
	$(PACKDIR)/assets/minecraft/textures/entity/pig/pig_saddle.png \
	$(PACKDIR)/assets/minecraft/textures/entity/villager/priest.png \
	$(PACKDIR)/assets/minecraft/textures/entity/villager/librarian.png \
	$(PACKDIR)/assets/minecraft/textures/misc/pumpkinblur.png \
	$(PACKDIR)/assets/minecraft/textures/misc/pumpkinblur.png.mcmeta

# slightly tweaked textures to make nostalgia and flavor textures mesh better
NOSTALGIA_FLAVOR = \
	$(PACKDIR)/assets/minecraft/textures/items/potato.png \
	$(PACKDIR)/assets/minecraft/textures/items/potato_baked.png \
	$(PACKDIR)/assets/minecraft/textures/items/potato_poisonous.png \
	$(PACKDIR)/assets/minecraft/textures/items/carrot_golden.png \
	$(PACKDIR)/assets/minecraft/textures/items/carrot.png \
	$(PACKDIR)/assets/minecraft/textures/items/cookie.png

# textures that didn't work out well
GROSS = \
	$(PACKDIR)/assets/minecraft/textures/blocks/bedrock.png \
	$(PACKDIR)/assets/minecraft/textures/items/potion_splash.png

# dirs for all of the above
DIRS     = \
	$(PACKDIR)/assets/minecraft/textures/entity/villager \
	$(PACKDIR)/assets/minecraft/textures/entity/pig \
	$(PACKDIR)/assets/minecraft/textures/blocks \
	$(PACKDIR)/assets/minecraft/textures/items \
	$(PACKDIR)/assets/minecraft/textures/misc

.PHONY: all
all: nostalgia flavor nostalgia-flavor

.PHONY: everything
everything: all gross

.PHONY: nostalgia
nostalgia: dirs $(NOSTALGIA) $(DEFAULT)

.PHONY: flavor
flavor: dirs $(FLAVOR) $(DEFAULT)

.PHONY: nostalgia-flavor
nostalgia-flavor: dirs $(NOSTALGIA_FLAVOR) $(DEFAULT)

.PHONY: gross
gross: dirs $(GROSS) $(DEFAULT)

$(PACKDIR)/%.png: pack/%.png
	cp $< $@

$(PACKDIR)/%.png.mcmeta: pack/%.png.mcmeta
	cp $< $@

$(PACKDIR)/pack.mcmeta: $(SRCDIR)/pack.mcmeta
	cp $< $@

$(PACKNAME).zip: $(PACKDIR)
	cd $< && zip -r $@ *
	mv $</$@ $@

.PHONY: dirs
dirs: $(DIRS)

$(DIRS):
	mkdir -p $@

.PHONY: install
install: $(PACKNAME).zip
	cp $(PACKNAME).zip $(MCDIR)/resourcepacks

.PHONY: clean
clean:
	rm -rf $(PACKDIR) $(PACKNAME).zip
	rm -rf example

.PHONY: uninstall
uninstall:
	rm -f $(MCDIR)/texturepacks/$(PACKNAME).zip

example:
	mkdir example
	cd example && jar xvf $(MCJAR) && rm -rf *.class META-INF/ achievement/ com/ paulscode/ lang/ net/

$(PACKNAME)-nostalgia.zip:
	make clean
	make nostalgia
	make nostalgia-flavor
	make $(PACKNAME).zip
	mv $(PACKNAME).zip $(PACKNAME)-nostalgia.zip

$(PACKNAME)-flavor.zip:
	make clean
	make flavor
	make $(PACKNAME).zip
	mv $(PACKNAME).zip $(PACKNAME)-flavor.zip

$(PACKNAME)-all.zip: all $(PACKNAME).zip
	mv $(PACKNAME).zip $(PACKNAME)-all.zip

.PHONY: dist
dist: $(PACKNAME)-nostalgia.zip $(PACKNAME)-flavor.zip $(PACKNAME)-all.zip

.PHONY: distclean
distclean: clean
	rm -f $(PACKNAME)-nostalgia.zip $(PACKNAME)-flavor.zip $(PACKNAME)-all.zip
