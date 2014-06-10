within Buildings.Electrical.Transmission.LowVoltageCables;
record Cu20 "Cu cable 20 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Types.Material.Cu,
    Amp=95,
    RCha=0.905e-003,
    XCha=0.075e-003);
end Cu20;
