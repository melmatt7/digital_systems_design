/* Quartus II 64-Bit Version 14.1.0 Build 186 12/03/2014 SJ Web Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEMA5F31) Path("C:/UBC/w2019-2020t2/CPEN311/digital_systems_design/Lab2/template_de1soc/") File("simple_ipod_solution.sof") MfrSpec(OpMask(1) SEC_Device(EPCS128) Child_OpMask(1 0));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
