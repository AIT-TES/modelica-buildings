within Buildings.Media.Examples;
model SteamTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.Examples.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium=Buildings.Media.Steam,
    T0=273.15+200,
    tol=1e-3);
initial equation
  assert(
    false,
    "In "+getInstanceName()+": This model is a beta version and is not fully validated yet.",
    level=AssertionLevel.warning);
  annotation (
    experiment(
      Tolerance=1e-6,
      StopTime=1.0),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Media/Examples/SteamTemperatureEnthalpyInversion.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p><b><span style=\"font-size: 11pt; color: #ff0000;\">This model is a beta version and is not fully validated yet. </span></b></p>
<p>This model tests whether the inversion of temperature and enthalpy is implemented correctly for the steam model. </p>
</html>",
      revisions="<html>
<ul>
<li>
March 24, 2020, by Kathryn Hinkelman:<br/>
Relaxed absolute error tolerance.
</li>
<li>
January 16, 2020, by Kathryn Hinkelman:<br/>
Change medium to ideal steam to eliminate property discontinuities.
</li>
<li>
September 12, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamTemperatureEnthalpyInversion;
