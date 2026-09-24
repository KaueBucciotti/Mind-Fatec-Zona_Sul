package com.mind_your.mind.mapper;

import com.mind_your.mind.dto.response.EnderecoResponseDTO;
import com.mind_your.mind.models.Endereco;

public class EnderecoMapper {

    public static EnderecoResponseDTO toResponseDTO(Endereco endereco) {
        if (endereco == null) {
            return null;
        }
        return new EnderecoResponseDTO(
                endereco.getCep(),
                endereco.getLogradouro(),
                endereco.getLocalidade(),
                endereco.getLogradouro(),
                endereco.getUf()
        );
    }
}
