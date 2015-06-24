within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Examples;
model VariableSpeed "Test model for variable speed water to water heat pump"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water;
  package Medium2 = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = datHP.heaMod.m1_flow_nominal
    "Medium1 nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = datHP.heaMod.m2_flow_nominal
    "Medium2 nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp1_nominal = 8000
    "Pressure drop at m1_flow_nominal";
  parameter Modelica.SIunits.Pressure dp2_nominal = 8000
    "Pressure drop at m2_flow_nominal";
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    p(displayUnit="Pa") = 101325,
    T=323.15,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Buildings.Fluid.Sources.Boundary_pT sou2(
    use_p_in=true,
    redeclare package Medium = Medium2,
    nPorts=1,
    T=293.15)
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325,
    T=298.15,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sou1(
    use_p_in=true,
    redeclare package Medium = Medium1,
    T=293.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Sources.Ramp p1(
    duration=600,
    offset=101325,
    height=2000,
    startTime=60) "Pressure"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.Ramp p2(
    duration=600,
    offset=101325,
    startTime=60,
    height=3000) "Pressure"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-30})));

  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.VariableSpeed varSpe(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    datHP=datHP,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Variable speed water to water heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.TimeTable heaSpeRat(table=[0,0; 600,0.5; 1200,1; 1800,
        0; 2400,0; 3000,0; 3600,0]) "Heating mode speed ratio"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.TimeTable cooSpeRat(table=[0,0; 600,0; 1200,0; 1800,0;
        2400,0.5; 3000,1; 3600,0]) "Cooling mode speed ratio"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Data.HPData datHP(cooMod(
      nSta=2,
      m1_flow_nominal=1.89,
      m2_flow_nominal=1.89,
      cooPer={
          Data.BaseClasses.CoolingPerformance(
          spe=1200,
          Q_flow_nominal=-39890.91,
          P_nominal=4790,
          cooCap={-1.52030596,3.46625667,-1.32267797,0.09395678,0.038975504},
          cooP={-8.59564386,0.96265085,8.69489229,0.02501669,-0.20132665}),
          Data.BaseClasses.CoolingPerformance(
          spe=2400,
          Q_flow_nominal=2*(-39890.91),
          P_nominal=2*4790,
          cooCap={-1.52030596,3.46625667,-1.32267797,0.09395678,0.038975504},
          cooP={-8.59564386,0.96265085,8.69489229,0.02501669,-0.20132665})}),
      heaMod(
      nSta=2,
      m1_flow_nominal=1.89,
      m2_flow_nominal=1.89,
      heaPer={
          Data.BaseClasses.HeatingPerformance(
          spe=1200,
          QHea_flow_nominal=39040.92,
          PHea_nominal=5130,
          heaCap={-3.33491153,-0.51451946,4.51592706,0.01797107,0.155797661},
          heaP={-8.93121751,8.57035762,1.29660976,-0.21629222,0.033862378}),
          Data.BaseClasses.HeatingPerformance(
          spe=2400,
          QHea_flow_nominal=2*39040.92,
          PHea_nominal=2*5130,
          heaCap={-3.33491153,-0.51451946,4.51592706,0.01797107,0.155797661},
          heaP={-8.93121751,8.57035762,1.29660976,-0.21629222,0.033862378})}))
    "Heat  pump data"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
equation
  connect(p1.y, sou1.p_in) annotation (Line(
      points={{-79,10},{-72,10},{-72,18},{-62,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p2.y, sou2.p_in) annotation (Line(
      points={{79,-30},{72,-30},{72,-22},{62,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou1.ports[1], varSpe.port_a1)   annotation (Line(
      points={{-40,10},{-30,10},{-30,6},{-10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin2.ports[1], varSpe.port_b2)   annotation (Line(
      points={{-40,-30},{-26,-30},{-26,-6},{-10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(varSpe.port_b1, sin1.ports[1])   annotation (Line(
      points={{10,6},{26,6},{26,10},{40,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(varSpe.port_a2, sou2.ports[1])   annotation (Line(
      points={{10,-6},{24,-6},{24,-30},{40,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooSpeRat.y, varSpe.cooSpeRat) annotation (Line(
      points={{-79,-30},{-70,-30},{-70,-10},{-34,-10},{-34,2},{-12,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaSpeRat.y, varSpe.heaSpeRat) annotation (Line(
      points={{-59,50},{-24,50},{-24,10},{-12,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToWater/Examples/VariableSpeed.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This is a test model for 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.VariableSpeed\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.VariableSpeed</a>. 
The model has open-loop control and time-varying input conditions. 
Pressure difference across both sides of heat pump is ramped up from zero to 2000 Pa and 3000 Pa respectively thus, this example tests zero mass flow rate condition. 
Also the control inputs i.e. the speed ratios of coil is varied along with mode of operation.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 08, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul></html>"));
end VariableSpeed;
