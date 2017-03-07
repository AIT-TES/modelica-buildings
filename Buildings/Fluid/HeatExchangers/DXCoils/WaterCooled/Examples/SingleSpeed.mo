within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples;
model SingleSpeed "Test model for single speed DX coil"

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
  extends Modelica.Icons.Example;
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";
 parameter Modelica.SIunits.PressureDifference dpEva_nominal = 1000
    "Pressure drop at m_flow_nominal";
 parameter Modelica.SIunits.PressureDifference dpCon_nominal = 40000
    "Pressure drop at mCon_flow_nominal";
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir,
    nPorts=1,
    p(displayUnit="Pa")) "Sink on air side"
    annotation (Placement(transformation(extent={{52,30},{32,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    nPorts=1,
    m_flow=1.5,
    T=299.85) "Source on air side"
    annotation (Placement(transformation(extent={{-48,28},{-28,48}})));
  Modelica.Blocks.Sources.BooleanStep onOff(startTime=600)
    "Compressor on-off signal"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{-90,32},{-70,52}})));
  Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.SingleSpeed sinSpeDX(
    redeclare package MediumEva = MediumAir,
    redeclare package MediumCon = MediumWater,
    datCoi=datCoi,
    dpEva_nominal=dpEva_nominal,
    dpCon_nominal=dpCon_nominal,
    show_T=true) "Single speed DX coil"
    annotation (Placement(transformation(extent={{-6,-6},{14,14}})));
  Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi(
      nSta=1,
      sta={Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,COP_nominal=3,SHR_nominal=0.8,
          m_flow_nominal=1.5,mCon_flow_nominal=1,TEvaIn_nominal=273.15+26.67,
          TConIn_nominal=273.15+29.4),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I())}) "Coil data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Ramp mCon_flow(
    duration=600,
    startTime=6000,
    height=0,
    offset=1) "Condenser inlet mass flow"
    annotation (Placement(transformation(extent={{92,-48},{72,-28}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWater,
    nPorts=1,
    use_T_in=false,
    use_m_flow_in=true,
    T=298.15) "Source on water side"
    annotation (Placement(transformation(extent={{52,-56},{32,-36}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWater,
    nPorts=1,
    p(displayUnit="Pa")) "Sink on water side"
    annotation (Placement(transformation(extent={{-44,-60},{-24,-40}})));
equation
  connect(TEvaIn.y, souAir.T_in) annotation (Line(
      points={{-69,42},{-50,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on)
                               annotation (Line(
      points={{-69,10},{-20,10},{-20,12.2},{-7,12.2}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(sinSpeDX.portCon_a, souWat.ports[1]) annotation (Line(points={{10,-6},
          {28,-6},{28,-46},{32,-46}}, color={0,127,255}));
  connect(sinSpeDX.portCon_b, sinWat.ports[1]) annotation (Line(points={{-2,-6},
          {-12,-6},{-12,-50},{-24,-50}}, color={0,127,255}));
  connect(souAir.ports[1], sinSpeDX.port_a) annotation (Line(points={{-28,38},{
          -12,38},{-12,4},{-6,4}}, color={0,127,255}));
  connect(sinAir.ports[1], sinSpeDX.port_b) annotation (Line(points={{32,40},{
          28,40},{28,4},{14,4}}, color={0,127,255}));
  connect(mCon_flow.y, souWat.m_flow_in) annotation (Line(points={{71,-38},{68,
          -38},{52,-38}},          color={0,0,127}));
  annotation (             __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/WaterCooled/Examples/SingleSpeed.mos"
        "Simulate and plot"),
    experiment(StopTime=3600),
            Documentation(info="<html>
<p>
This is a test model for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.SingleSpeed</a>.
The model has open-loop control and time-varying input conditions.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/404\">#404</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleSpeed;
