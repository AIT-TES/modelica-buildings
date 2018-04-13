within Buildings.ThermalZones.EnergyPlus.BaseClasses;
block FMUZoneAdapter "Block that interacts with this EnergyPlus zone"
  extends Modelica.Blocks.Icons.Block;

  parameter String idfName "Name of the IDF file that contains this zone";
  parameter String weaName "Name of the Energyplus weather file";
  final parameter String iddName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Rooms/EnergyPlus/Energy+.idd")
    "Name of the Energyplus IDD file";
  final parameter String epLibName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Rooms/EnergyPlus/libepfmi.so")
    "Name of the EnergyPlus FMI library";
  parameter String zoneName
    "Name of the thermal zone as specified in the EnergyPlus input";
  parameter Integer nFluPor
    "Number of fluid ports (Set to 2 for one inlet and one outlet)";

  final parameter Modelica.SIunits.Area AFlo(fixed=false) "Floor area";
  final parameter Modelica.SIunits.Volume V(fixed=false) "Zone volume";
  final parameter Real mSenFac(fixed=false)
    "Factor for scaling the sensible thermal mass of the zone air volume";
  Modelica.Blocks.Interfaces.RealInput T(
    final unit="K",
    displayUnit="degC")
    "Zone air temperature" annotation (
      Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput X_w(final unit="kg/kg")
    "Zone air mass fraction in kg/kg total air" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent=
           {{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput m_flow[nFluPor](
     each final unit = "kg/s")
     "Mass flow rate" annotation (
      Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TInlet[nFluPor](
    each final unit="K",
    each displayUnit="degC") "Air inlet temperatures"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput QGaiRad_flow(
    final unit="W") "Radiative heat gain"
                          annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput TRad(
    final unit="K",
    displayUnit="degC")
    "Radiative temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
    "Convective sensible heat to be added to zone air" annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={{
            100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QLat_flow(final unit="W")
    "Latent heat to be added to zone air" annotation (Placement(transformation(
          extent={{100,-30},{120,-10}}), iconTransformation(extent={{100,-30},{120,
            -10}})));
  Modelica.Blocks.Interfaces.RealOutput QPeo_flow(
    final unit="W")
    "Total heat gain from people, to be used for optional computation of CO2 released"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Modelica.SIunits.Time tNext(start=t0-1, fixed=true) "Next sampling time";
  Modelica.SIunits.Time tNextEP(start=t0-1, fixed=true) "Next sampling time requested from EnergyPlus";
 // constant Real dT_dtMax(unit="K/s") = 0.000001 "Bound on temperature derivative to reduce or increase time step";
//  Modelica.SIunits.Time dtMax(displayUnit="min", start=600, fixed=true) "Maximum time step before next sampling";

protected
  Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUZoneClass adapter=
      Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUZoneClass(
      idfName=idfName,
      weaName=weaName,
      iddName=iddName,
      epLibName=epLibName,
      zoneName=zoneName)
        "Class to communicate with EnergyPlus";

  parameter Modelica.SIunits.Time t0(fixed=false) "Simulation start time";

  Modelica.SIunits.Temperature T0 "Room air temperature at last sampling";
  Modelica.SIunits.HeatFlowRate QCon0_flow
    "Convective sensible heat to be added to zone air if T = T0";
  Real dQCon_flow(unit="W/K")
    "Derivative dQCon_flow / dT";

  function roundToMinute
    input Real u;
    output Real y;
  algorithm
    y :=if (u > 0) then floor(u/60. + 0.5)*60 else ceil(u/60. - 0.5)*60;
  end roundToMinute;

initial equation
  t0 = time;
  (AFlo, V, mSenFac) = Buildings.ThermalZones.EnergyPlus.BaseClasses.initialize(adapter);
  T0 = T;
equation
  when {initial(), time >= pre(tNext)} then
    T0 = T;
    (TRad, QCon0_flow, dQCon_flow, QLat_flow, QPeo_flow, tNextEP) =
      Buildings.ThermalZones.EnergyPlus.BaseClasses.exchange(
      adapter,
      T,
      X_w,
      m_flow,
      TInlet,
      QGaiRad_flow,
      time);
    // Guard against division by zero in first call
    //dtMax = min(tNextEP-time, round(dTMax * V * 1.2 *1006/max(1, abs(QCon_flow))/60)*60);
    //    if dT_dt > dT_dtMax then
//      dtMax = max(60, pre(dtMax)/10);
//    elseif dT_dt < dT_dtMax/2 then
//      dtMax = min(10 * pre(dtMax), 1800);
//    else
//      dtMax = pre(dtMax);
//   end if;

    //tNext = roundToMinute(min(tNextEP, time+dtMax));
    //tNext = roundToMinute(min(tNextEP, time+60));
    tNext = tNextEP;
  end when;
  QCon_flow = QCon0_flow + (T-T0) * dQCon_flow;

  annotation (Icon(graphics={Bitmap(extent={{-90,-86},{84,88}}, fileName=
            "modelica://Buildings/Resources/Images/Fluid/FMI/FMI_icon.png")}),
      Documentation(info="<html>
<p>
Block that exchanges data between Modelica and EnergyPlus.
This block is calling the C functions to initialize EnergyPlus,
exchange data with EnergyPlus, and free the memory, through the destructor
of its class <code>adapter</code>, of EnergyPlus.
</p>
</html>", revisions="<html>
<ul>
<li>
April 04, 2018, by Thierry S. Nouidui:<br/>
Added additional parameters for parametrizing 
the EnergyPlus model.
</li>
<li>
March 21, 2018, by Thierry S. Nouidui:<br/>
Revised implementation for efficiency.
</li>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FMUZoneAdapter;
