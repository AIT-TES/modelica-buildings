within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations;
record corUAMerkel "UA correction for Merkel cooling towers"
  extends Modelica.Icons.Record;

 constant Integer nUAFunDifWB=3 "Number of coefficients for UAFunDifWB"
    annotation (Dialog(group="Performance curves"));
  constant Integer nUAFunAirFra=3 "Number of coefficients for UAFunAirFra"
    annotation (Dialog(group="Performance curves"));
  constant Integer nUAFunWatFra=3 "Number of coefficients for UAFunWatFra"
    annotation (Dialog(group="Performance curves"));
  parameter Real UAFunDifWB[nUAFunDifWB]={1,0.0081,0} "Polynomial coefficients for UAFunDifWB"
    annotation (Dialog(group="Performance curves"));
  parameter Real UAFunAirFra[nUAFunAirFra]={0,1.3,-0.3} "Polynomial coefficients for UAFunAirFra"
    annotation (Dialog(group="Performance curves"));
  parameter Real UAFunWatFra[nUAFunWatFra]={0.1082,1.667,-0.7713} "Polynomial Coefficients for UAFunWatFra"
    annotation (Dialog(group="Performance curves"));

  parameter Real FRAirMin(min=0) = 0.2 "Minimum value for air flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRAirMax(min=0)= 1.0 "Maximum value for ari flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRWatMin(min=0) = 0.3 "Minimum value for water flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRWatMax(min=0) = 1.0 "Maximum value for water flow fraction"
    annotation (Dialog(group="Performance curves"));

     // Range for the curves
  parameter Modelica.SIunits.TemperatureDifference TDiffWBMin(displayUnit="K")= -10
    "Minimum value for leaving evaporator temperature"
    annotation (Dialog(group="Performance curves"));
  parameter Modelica.SIunits.TemperatureDifference TDiffWBMax(displayUnit="K")= 25
    "Maximum value for leaving evaporator temperature"
    annotation (Dialog(group="Performance curves"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end corUAMerkel;
