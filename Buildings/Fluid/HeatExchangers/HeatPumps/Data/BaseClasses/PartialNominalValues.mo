within Buildings.Fluid.HeatExchangers.HeatPumps.Data.BaseClasses;
record PartialNominalValues "Data record of nominal values"
  extends Modelica.Icons.Record;

//-----------------------------Nominal conditions-----------------------------//
  parameter Real COP_nominal "Nominal coefficient of performance"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Nominal mass flow rate for medium 1"
    annotation (Dialog(group="Nominal condition"));
   parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Nominal mass flow rate for medium 2"
     annotation (Dialog(group="Nominal condition"));

  parameter Real phi1In_nominal=0.5
    "Relative humidity of entering air at nominal condition"
      annotation(Dialog(tab="General",group="Nominal condition"));
  parameter Modelica.SIunits.Pressure p1_nominal=101325
    "Inlet air nominal pressure"
    annotation(Dialog(tab="General",group="Nominal condition"));

//   parameter Real wasHeaRecFra_nominal=0.2
//     "Waste heat recovery fraction of power input at nominal condition"
//       annotation(Dialog(tab="General",group="Nominal condition"));

annotation (defaultComponentName="nomVal",
              preferedView="info",
  Documentation(info="<html>
  <p>
This is the base record of nominal values for heat pump models. 
</p>
<p>
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 24, 2013 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialNominalValues;
