# quartus_modelsim_makefile
Quartus PrimeおよびModelSimASEを操作するMakefileのサンプル. Makefileの基本的な構造などは参考[[1](#omilab),[2](#boysenberrypi)]に譲る. 動作環境は以下の通り.
This is the sample of Makefile that work on Quartus Prime and ModelSimASE. The basic description of Makefile is introduced in references[[1](#omilab),[2](#boysenberrypi)]. The operating environment is below.

Quartus Prime 18.0.0 Build 614 04/24/2018 SJ Lite Edition  
ModelSim - Intel FPGA Starter Edition 10.5b 2016.10  
Altera Nios2 Command Shell 18.0 Build 614 or  
Windows Subsystem for Linux(WSL) Ubuntu 16.04.6 LTS

基本的なディレクトリ構造は以下の通り.
The directory structure as follows:

```bash
.
├── DECODER.qpf
├── DECODER.qsf
├── docs
├── Makefile
├── pld
│   └── DECODER.vhd
└── testbench
    └── TB_DECODER.sv
```

FPGAのソースファイルは`pld`に配置する. VHDLを想定しているがVerilog HDLの場合はMakefile内の拡張子を書き換えればよい. テストベンチファイルは`testbench`に配置する. SystemVerilogを想定している.
Source files of FPGA are placed in `pld`. It is assumed to be built in VHDL, so in Verilog HDL, the extension in Makefile should be rewritten. Testbench files are placed in` testbench`. Testbench files are SystemVerilog.

## Usage

プログラミングファイルの生成, シミュレーションの実行.
Generate programing file. Run simulation.

```bash
$make {all}
```

`all`は不要.
`all` is not required.

シミュレーションの実行のみ.
Only Simulate.

```bash
$make check
```

## Detail

**l.12**

```makefile
MODELSIM_SIM_FLAGS = -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"
```

QuartusのNativeLinkによるシミュレーションの実行より抜粋. Altera(Intel)デバイス特有のライブラリ追加と最適化プロセスの抑制(`-voptargs="+acc"`).
Excerpt from Quartus NativeLink simulation. Add  Altera(Intel) device libraries and suppress optimization process(`-voptargs="+acc"`).

**l.14**

```makefile
lib_exist := $(shell find -maxdepth 1 -name rtl_work -type d)
```

`rtl_work`ディレクトリの存在確認[[3](#dir_exits)]. シミュレーション用ライブラリ生成に使用.
Check that the `rtl_work` directory exists[[3](#dir_exits)]. `rtl_work` is used to create libraries for simulation.

**l.18**

```makefile
$(PRG) : $(PLD_DIR)/*.vhd
	quartus_sh.exe --flow compile $(PROJECT)
```

コンパイルの一括実行. `pld`のソースファイルが変更されているときのみ実行.
Batch compilation. Executed only when the source files in `pld` has been changed.

**l.21**

```makefile
check: ./rtl_work/
	vmap.exe work rtl_work
	vcom.exe -93 $(MODELSIM_LIB_FLAGS) $(PLD_DIR)/PAC_*.vhd
	vcom.exe -93 $(MODELSIM_LIB_FLAGS) $(PLD_DIR)/*.vhd
	vlog.exe -sv $(MODELSIM_LIB_FLAGS) +incdir+$(TB_DIR) $(TB_SRC)
	vsim.exe -c TB_$(PROJECT) -do "run -all;quit"
```

シミュレーションの実行. ソースファイルはVHDL 1993を想定.
Run simulation. Source files are VHDL 1993.

```makefile
	vcom.exe -93 ~ $(PLD_DIR)/*.vhd
```

ソースファイルの中でパッケージファイルがある場合, 先に登録する必要があるため, 
When package files exist in source files, because package files must are registered first, do the following first.

```makefile
	vcom.exe -93 $(MODELSIM_LIB_FLAGS) $(PLD_DIR)/PAC_*.vhd
```

を先に実行. パッケージファイルの命名則は`PAC_*`.
Package file naming convention is `PAC_ *`


テストベンチファイルはSystemVerilogを想定.
Testbench files are SystemVerilog.

```makefile
	vlog.exe -sv ~
```

**l.28**

```makefile
./rtl_work/: $(TB_SRC)
	$(if $(lib_exist),vdel.exe -lib rtl_work -all)
```

テストベンチファイルが更新されていたときのみ`rtl_work`ライブラリを更新. すでに`rtl_work`ディレクトリが存在する場合は削除.
Update the `rtl_work` library only when the test bench file has been updated. Delete the` rtl_work` directory if it already exists.


## Bibliography

[1]<a name="omilab"></a>[ Makefileの解説](http://omilab.naist.jp/~mukaigawa/misc/Makefile.html)  
[2]<a name="boysenberrypi"></a>[汎用的に使えそうなMakefileを書いてみた - 落書き以上、技術メモ以下](http://boysenberrypi.hatenadiary.jp/entry/2014/03/15/113703)  
[3]<a name="dir_exits"></a>[ファイルが存在している場合だけ処理する方法, ifでフロー制御 ( GNU Make ) - my notebook blog](https://osima.jp/make-if-file-exists.html)  

## License

MIT License

## Author

[toms74209200](<https://github.com/toms74209200>)