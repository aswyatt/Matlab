% Constants: Class definition of physical constants
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)

classdef Constants
	%	========================================================================
	%	S I   B A S E   U N I T S
	%	========================================================================
	properties(Constant)
		Avogadro = 6.02214076e23;			%	N_A [mol^-1]
		Boltzmann = 1.380649e-23;			%	k_B [kg m^2 K^-1 s^-2]
		CaesiumFrequency = 9192631770;		%	Cs_dnu[Hz or s^-1]
		Candela = 683;						%	Cd [cd sr s^3 kg^-1 m^-2]
		ElectronCharge = 1.602176634e-19;	%	e [A s]
		Planck = 6.62607015e-34;			%	h [kg m^2 s^-1]
		SpeedOfLight = 299792458;			%	c [m/s]
	end
	
	%	Short-form
	properties(Constant, Hidden)
		N_A = Constants.Avogadro;
		k_B = Constants.Boltzmann;
		K_cd = Constants.Candela;
		Cs_dnu = Constants.CaesiumFrequency;
		e = Constants.ElectronCharge;
		c = Constants.SpeedOfLight;
		h = Constants.Planck;
	end
	
	
	%	========================================================================
	%	F U N D A M E N T A L   C O N S T A N T S
	%	========================================================================
	properties (Constant)
		%	Atomic length (a_0 = 4pi * eps_0 * h_bar^2 / (m_e * e^2) ~ 5.29e-11 m)
		BohrRadius = 5.29177210903e-11;
		
		%	Coulomb constant (k_e: 1/4*pi*eps_0 ~ 8.99e9 N m^2 / C^2)
		Coulomb = 8.9875517923e9;
		
		%	Electron rest mass (m_e)
		ElectronMass = 9.1093837015e-31;
		
		%	Fine structure constant (alpha)
		FineStructure = 7.2973525693e-3;
		
		%	Newton's gravitational constant (G)
		Gravitation = 6.67430e-11;
		
		%	Hartree energy (E_H = 4.36e-18 J)
		HartreeEnergy = 4.3597447222071e-18;
		
		%	Permeability of free space (mu_0 = 4e-7*pi ~ 1.26e-6 m kg / s^2 / A^2)
		Permeability = 4e-7*pi * (1+55e-11);
		
		%	Permittivity of free space (eps_0 = 1/(4pi*k_e) ~ 8.85e-12 s^4 A^2 / m^3 / kg^1)
		Permittivity = 8.8541878128e-12;
		
		%	Rydberg (R_inf = alpha^2 * m_e * c / 2h)
		Rydberg = 10973731.568160;
	end
	
	%	Short-form
	properties (Constant, Hidden)
		a_0 = Constants.BohrRadius;
		k_e = Constants.Coulomb;
		m_e = Constants.ElectronMass;
		alpha = Constants.FineStructure;
		G = Constants.Gravitation;
		E_H = Constants.HartreeEnergy;
		mu_0 = Constants.Permeability;
		eps_0 = Constants.Permittivity;
		R_inf = Constants.Rydberg;
	end
	
	
	%	========================================================================
	%	D E R I V E D   C O N S T A N T S
	%	========================================================================
	properties (Constant)
		
		%	Reduced Planck's constant (h_bar = h/2pi = 1.05e-34 J s)
		ReducedPlanck = Constants.h/(2*pi);
		
		%	Universal gas constant (R = N_A * k_B ~ 8.314472 J / K / mol):
		MolarGas = Constants.N_A * Constants.k_B;
		
	end
	
	%	Short-form
	properties (Constant, Hidden)
		h_bar  = Constants.ReducedPlanck;
		R = Constants.MolarGas;
	end
	
	%	========================================================================
	%	A T O M I C   U N I T S
	%	========================================================================
	properties (Constant)
		Action = Constants.h_bar;
		Charge = Constants.e;
		Current = Constants.e * Constants.E_H / Constants.h_bar;
		ElectricField = Constants.E_H/(Constants.e * Constants.a_0);
		ElectricPotential = Constants.E_H/Constants.e;
		Energy = Constants.E_H;
		Force = Constants.E_H/Constants.a_0;
		Length = Constants.a_0;
		Mass = Constants.m_e;
		Momentum = Constants.h_bar / Constants.a_0;
		Time = Constants.h_bar / Constants.E_H;
		Velocity = Constants.Length*Constants.E_H/Constants.h_bar;
	end
	
		methods (Static)
			%	Convert from SI to Hartree atomic units
			%	(h_bar = e = m_e = a_0 = 1/(4pi*eps_0) = 1)
			function val = SItoAU(str, val)
				arguments
					str string {mustBeMember(str, ["Action" "Charge" ...
						"Current" "ElectricField" "ElectricPotential" ...
						"Energy" "Force" "Length" "Mass" "Momentum" "Time" ...
						"Velocity"])}
					val {mustBeNumeric}
				end
				val = val ./ Constants.(str);
			end
			
			%	Convert from Hartree atomic to SI units
			function val = AUtoSI(str, val)
				arguments
					str string {mustBeMember(str, ["Action" "Charge" ...
						"Current" "ElectricField" "ElectricPotential" ...
						"Energy" "Force" "Length" "Mass" "Momentum" "Time" ...
						"Velocity"])}
					val {mustBeNumeric}
				end
				val = val .* Constants.(str);
			end
		end
end