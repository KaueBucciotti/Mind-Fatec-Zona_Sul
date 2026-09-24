package com.mind_your.mind.dto.response;

public class EnderecoResponseDTO {
    private String cep;
    private String logradouro;
    private String cidade;
    private String rua;
    private String uf;

    public EnderecoResponseDTO(String cep, String logradouro, String cidade, String rua, String uf) {
        this.cep = cep;
        this.logradouro = logradouro;
        this.cidade = cidade;
        this.rua = rua;
        this.uf = uf;
    }

    public String getCep() { return cep; }

    public void setCep(String cep) { this.cep = cep; }

    public String getLogradouro() { return logradouro; }

    public void setLogradouro(String logradouro) { this.logradouro = logradouro; }


    public String getCidade() { return cidade; }

    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getRua() { return rua; }

    public void setRua(String rua) { this.rua = rua; }

    public String getUf() { return uf; }

    public void setUf(String uf) { this.uf = uf; }
}

