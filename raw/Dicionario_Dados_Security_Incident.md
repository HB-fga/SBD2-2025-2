# Dicionário de Dados - Microsoft Security Incident Prediction

## Informações Gerais

**Nome do Dataset:** Microsoft Security Incident Prediction  
**Fonte:** [Kaggle - Microsoft Security Incident Prediction](https://www.kaggle.com/datasets/Microsoft/microsoft-security-incident-prediction/data?select=GUIDE_Train.csv)  
**Tipo de Problema:** Classificação Binária  
**Objetivo:** Predizer se uma máquina Windows terá um incidente de segurança  
**Variável Target:** `HasDetections` (0 = Sem incidente, 1 = Com incidente)  

## Descrição do Dataset

Este dataset contém dados de telemetria coletados de máquinas Windows para identificar padrões que podem indicar incidentes de segurança. Os dados incluem informações sobre:

- Características do sistema operacional
- Configurações de hardware
- Software instalado
- Configurações de segurança
- Características comportamentais do sistema

## Categorias de Variáveis

### 1. Identificadores
- **MachineIdentifier:** Identificador único da máquina Windows
- **HasDetections:** Variável target indicando presença de incidente de segurança (0/1)

### 2. Características do Sistema Operacional
- **ProductName:** Nome do produto Windows (ex: Windows 10, Windows 11)
- **EngineVersion:** Versão do motor de detecção de segurança
- **AppVersion:** Versão da aplicação de segurança
- **AvSigVersion:** Versão da assinatura do antivírus
- **Platform:** Plataforma do sistema operacional
- **Processor:** Tipo de processador
- **OsVer:** Versão do sistema operacional
- **OsPlatformSubRelease:** Sub-release da plataforma
- **OsBuildLab:** Build específico do sistema operacional
- **SkuEdition:** Edição do SKU do Windows

### 3. Configurações de Segurança
- **IsProtected:** Indica se a máquina está protegida por antivírus
- **AutoSampleOptIn:** Opt-in para amostragem automática de arquivos
- **PuaMode:** Modo para Potentially Unwanted Applications
- **SMode:** Modo S do Windows (modo restrito)
- **IeVerIdentifier:** Identificador da versão do Internet Explorer
- **SmartScreen:** Status do Windows SmartScreen
- **Firewall:** Status do Windows Firewall
- **UacLuaenable:** Status do User Account Control (UAC)

### 4. Características de Hardware
- **Census_MDC2FormFactor:** Formato do dispositivo (desktop, laptop, tablet)
- **Census_DeviceFamily:** Família do dispositivo
- **Census_OEMNameIdentifier:** Identificador do fabricante (OEM)
- **Census_OEMModelIdentifier:** Identificador do modelo específico
- **Census_ProcessorCoreCount:** Número de cores do processador
- **Census_ProcessorModelIdentifier:** Identificador do modelo do processador
- **Census_ProcessorClass:** Classe do processador
- **Census_PrimaryDiskTotalCapacity:** Capacidade total do disco primário
- **Census_PrimaryDiskTypeName:** Tipo do disco primário (HDD, SSD)
- **Census_SystemVolumeTotalCapacity:** Capacidade do volume do sistema
- **Census_HasOpticalDiskDrive:** Presença de drive óptico
- **Census_TotalPhysicalRAM:** Quantidade total de RAM física
- **Census_ChassisTypeName:** Tipo de chassi do dispositivo

### 5. Características de Display
- **Census_InternalPrimaryDiagonalDisplaySizeInInches:** Tamanho da tela em polegadas
- **Census_InternalPrimaryDisplayResolutionHorizontal:** Resolução horizontal da tela
- **Census_InternalPrimaryDisplayResolutionVertical:** Resolução vertical da tela

### 6. Características de Energia
- **Census_PowerPlatformRoleName:** Papel da plataforma de energia
- **Census_InternalBatteryType:** Tipo de bateria interna
- **Census_InternalBatteryNumberOfCharges:** Número de ciclos de carga da bateria

### 7. Características do Sistema Operacional (Detalhadas)
- **Census_OSVersion:** Versão completa do sistema operacional
- **Census_OSArchitecture:** Arquitetura do sistema (x64, x86)
- **Census_OSBranch:** Branch do sistema operacional
- **Census_OSBuildNumber:** Número de build do sistema
- **Census_OSBuildRevision:** Revisão do build
- **Census_OSEdition:** Edição do sistema operacional
- **Census_OSSkuName:** Nome do SKU do sistema operacional
- **Census_OSInstallTypeName:** Tipo de instalação do sistema
- **Census_OSInstallLanguageIdentifier:** Idioma de instalação
- **Census_OSUILocaleIdentifier:** Localização da interface do usuário
- **Census_OSWUAutoUpdateOptionsName:** Configurações de atualização automática

### 8. Características de Segurança do Sistema
- **Census_IsPortableOperatingSystem:** Sistema operacional portátil
- **Census_GenuineStateName:** Estado de autenticidade do Windows
- **Census_ActivationChannel:** Canal de ativação do Windows
- **Census_IsFlightingInternal:** Modo de teste interno
- **Census_IsFlightsDisabled:** Voos desabilitados
- **Census_FlightRing:** Anel de voo do sistema
- **Census_ThresholdOptIn:** Opt-in de threshold

### 9. Características do Firmware
- **Census_FirmwareManufacturerIdentifier:** Fabricante do firmware
- **Census_FirmwareVersionIdentifier:** Versão do firmware
- **Census_IsSecureBootEnabled:** Secure Boot habilitado
- **Census_IsWIMBootEnabled:** WIM Boot habilitado

### 10. Características do Dispositivo
- **Census_IsVirtualDevice:** Dispositivo virtual
- **Census_IsTouchEnabled:** Tela touch habilitada
- **Census_IsPenCapable:** Capacidade de usar caneta
- **Census_IsAlwaysOnAlwaysConnectedCapable:** Sempre conectado

### 11. Características de Uso
- **Wdft_IsGamer:** Perfil de gamer
- **Wdft_RegionIdentifier:** Identificador da região geográfica

## Observações Importantes

### Qualidade dos Dados
1. **Alta Dimensionalidade:** O dataset possui mais de 80 features, muitas podem ser redundantes
2. **Dados Ausentes:** Presença significativa de valores ausentes que requerem tratamento
3. **Variáveis Categóricas:** Maioria das variáveis são categóricas e precisam de encoding
4. **Desbalanceamento:** Possível desbalanceamento entre classes de incidentes
5. **Correlações:** Muitas variáveis podem estar altamente correlacionadas

### Desafios de Processamento
- **Memória:** Dataset grande pode consumir muita RAM
- **Encoding:** Necessidade de converter variáveis categóricas para numéricas
- **Feature Engineering:** Criação de novas features pode melhorar a performance
- **Seleção de Features:** Identificação das variáveis mais relevantes

### Estratégias de Tratamento
1. **Tratamento de Valores Ausentes:** Imputação ou remoção de colunas com muitos nulos
2. **Encoding de Variáveis Categóricas:** Label encoding, one-hot encoding, ou target encoding
3. **Redução de Dimensionalidade:** PCA, seleção de features, ou agrupamento
4. **Balanceamento de Classes:** Oversampling, undersampling, ou técnicas avançadas

## Próximos Passos

1. **Análise Exploratória:** Compreender distribuições e padrões nos dados
2. **Limpeza de Dados:** Tratar valores ausentes e outliers
3. **Engenharia de Features:** Criar novas variáveis e transformar existentes
4. **Seleção de Features:** Identificar variáveis mais preditivas
5. **Modelagem:** Aplicar algoritmos de classificação
6. **Avaliação:** Medir performance e otimizar parâmetros
7. **Validação:** Testar generalização do modelo

## Referências

- [Kaggle - Microsoft Security Incident Prediction](https://www.kaggle.com/datasets/Microsoft/microsoft-security-incident-prediction)
- [Microsoft Security Documentation](https://docs.microsoft.com/en-us/windows/security/)
- [Windows Defender Documentation](https://docs.microsoft.com/en-us/windows/security/threat-protection/)
