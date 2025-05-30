#!/bin/bash

echo "Realtek Wi-Fi driver Auto install script"
echo "Datum: Mei 2025"

# Stap 1: Ga naar de driver map
cd driver || { echo "Map driver niet gevonden!"; exit 1; }

# Stap 2: Pak de broncode uit als er een tar.gz is
tarball=$(ls *.tar.gz 2>/dev/null)
if [ -n "$tarball" ]; then
  echo "Uitpakken van $tarball..."
  tar -zxvf "$tarball" || { echo "Uitpakken mislukt!"; exit 1; }
fi

# Stap 3: Ga naar de uitgepakte map (neem aan dat er één is)
driver_folder=$(ls -d */ | head -n 1)
cd "$driver_folder" || { echo "Driver map niet gevonden!"; exit 1; }

# Stap 4: Schoon oude builds op
echo "Oude builds schoonmaken..."
make clean

# Stap 5: Build de driver
echo "Bouwen van driver..."
make || { echo "Build mislukt!"; exit 1; }

# Stap 6: Installeer de driver
echo "Installeren van driver..."
sudo make install || { echo "Installatie mislukt!"; exit 1; }

# Stap 7: Laad de module opnieuw
module_name="rtl8723bs"
echo "Herladen van module $module_name..."
sudo modprobe -r $module_name
sudo modprobe $module_name

echo "Installatie voltooid! Herstart je computer als het nog niet werkt."
