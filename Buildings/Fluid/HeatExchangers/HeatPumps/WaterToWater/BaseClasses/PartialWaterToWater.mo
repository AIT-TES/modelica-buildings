within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses;
partial model PartialWaterToWater
  "Partial model for water source water heater/cooler"
  import Buildings;
  extends Interfaces.FourPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      nPorts=2));

  parameter Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.HPData   datHP
    "Heat pump data";
//   Modelica.SIunits.Temperature  T_nominal= datHP.heaMod.T_nominal
//     "Nominal fluid temperature";
//   Modelica.SIunits.Pressure p_nominal=datHP.heaMod.p_nominal "Nominal pressure";
  Modelica.SIunits.SpecificEnthalpy hIn1=
    inStream(port_a1.h_outflow) "Enthalpy of water entering the heat pump";
  Modelica.SIunits.Temperature TIn1 = Medium1.temperature_ph(p=port_a1.p, h=hIn1)
    "Temperature of water entering the heat pump";
  Modelica.SIunits.SpecificEnthalpy hIn2=
    inStream(port_a2.h_outflow) "Enthalpy of water entering the heat pump";
  Modelica.SIunits.Temperature TIn2 = Medium2.temperature_ph(p=port_a2.p, h=hIn2)
    "Temperature of water entering the heat pump";
  Modelica.SIunits.Density rho1 = Medium1.density_pT(p=port_a1.p, T=TIn1)
    "Medium1 density"; //Medium1.setState_ph(p=port_a1.p, h=hIn1)
//   Modelica.SIunits.Density rho1_nominal1 = Medium1.density_pT(p=p_nominal, T=T_nominal)
//     "Medium1 nominal density";
  Modelica.SIunits.Density rho2 = Medium2.density_pT(p=port_a2.p, T=TIn2)
    "Medium2 density";
//   Modelica.SIunits.Density rho2_nominal2 = Medium2.density_pT(p=p_nominal, T=T_nominal)
//     "Medium2 nominal density";

   final parameter Boolean steadyStateOpe = if (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) then true else false
    "Boolean parameter for dynamic and steady state operation"
     annotation(Evaluate=true);

// Note: Boolean variable steadyStateOpe is not used in enabling the parameters annotation becuase the enable command
// only works directly with with the dependent parameter

  parameter Modelica.SIunits.Time tauOn = 15
    "Equipment on time constant; enabled only if energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState"
     annotation (Evaluate=true, Dialog(tab = "Dynamics", group="Nominal condition",
     enable = not (if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then true else false)));
                                             //if not steadyStateOpe
  parameter Modelica.SIunits.Time tauOff = 30
    "Equipment off time constant; enabled only if energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState"
    annotation (Evaluate=true, Dialog(tab = "Dynamics", group="Nominal condition",
    enable = not (if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then true else false)));
                                              //if not steadyStateOpe

  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power",unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},rotation=0)));

  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatFlow   heaFlo(
    datHP=datHP) "Calculates heat flow from source to load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  HeatTransfer.Sources.PrescribedHeatFlow qVol1 "Heat extracted by coil"
    annotation (Placement(transformation(extent={{60,30},{40,50}})));
  HeatTransfer.Sources.PrescribedHeatFlow qVol2 "Heat extracted by coil"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
  Modelica.Blocks.Sources.RealExpression m1(final y=port_a1.m_flow)
    "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.RealExpression m2(final y=port_a2.m_flow)
    "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-42},{-60,-22}})));
  Modelica.Blocks.Sources.RealExpression T1(final y=TIn1) "Medium1 temperature"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
  Modelica.Blocks.Sources.RealExpression T2(final y=TIn2) "Medium2 temperature"
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
public
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DynamicStartStop
    dynStaSto2(tauOn=tauOn, tauOff=tauOff,
    steadyStateOpe=steadyStateOpe) "Dynamic start "
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DynamicStartStop
    dynStaSto1(tauOn=tauOn, tauOff=tauOff,
    steadyStateOpe=steadyStateOpe) "Dynamic start"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
protected
  Modelica.Blocks.Sources.RealExpression rho[4](final y={rho1,rho2,rho1_nominal,rho2_nominal})
    "Density"
    annotation (Placement(transformation(extent={{-80,-58},{-60,-38}})));
// initial algorithm
//   assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
//           ((tauOn > Modelica.Constants.eps) and (tauOff > Modelica.Constants.eps)),
// "The parameter tauOn and/or tauOff of the model unreasonably small.
//  That indicates the model responds instantaneously to the the control signals.
//  Set the model to energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
//  or enter reasonable values for tauOn and tauOff.
//  Received tauOn = " + String(tauOn) + " and tauOff = " + String(tauOff) + "\n");

equation
  connect(qVol2.port, vol2.heatPort)
                                    annotation (Line(
      points={{40,-40},{26,-40},{26,-60},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(qVol1.port, vol1.heatPort)
                                    annotation (Line(
      points={{40,40},{-20,40},{-20,60},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(T1.y,heaFlo. T1) annotation (Line(
      points={{-59,16},{-39,16},{-39,4},{-11,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1.y,heaFlo. m1_flow) annotation (Line(
      points={{-59,6.10623e-16},{-34,6.10623e-16},{-34,0},{-22,0},{-22,1},{-11,
          1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y,heaFlo. T2) annotation (Line(
      points={{-59,-16},{-26,-16},{-26,-2},{-11,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2.y,heaFlo. m2_flow) annotation (Line(
      points={{-59,-32},{-20,-32},{-20,-5},{-11,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo.P, P) annotation (Line(
      points={{11,6.10623e-16},{57.5,6.10623e-16},{57.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(heaFlo.Q2_flow, dynStaSto2.u) annotation (Line(
      points={{11,-4},{24,-4},{24,-20},{38,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo.Q1_flow, dynStaSto1.u) annotation (Line(
      points={{11,4},{24,4},{24,20},{38,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dynStaSto1.y, qVol1.Q_flow) annotation (Line(
      points={{61,20},{80,20},{80,40},{60,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dynStaSto2.y, qVol2.Q_flow) annotation (Line(
      points={{61,-20},{80,-20},{80,-40},{60,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rho.y, heaFlo.rho) annotation (Line(
      points={{-59,-48},{-16,-48},{-16,-8},{-11,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics),
              defaultComponentName="watToWatHP",  Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.MultiStage\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.MultiStage</a>, 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.SingleSpeed\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.SingleSpeed</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.VariableSpeed\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.VariableSpeed</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 10, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end PartialWaterToWater;
