package com.mind_your.mind.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import com.mind_your.mind.models.Endereco;
import com.mind_your.mind.dto.response.EnderecoResponseDTO;
import com.mind_your.mind.mapper.EnderecoMapper;

@Service
public class EnderecoService implements IEnderecoService {
    
    private static final String API_URL = "https://viacep.com.br/ws/{cep}/json/";

    @Autowired
    private RestTemplate restTemplate;

    public EnderecoService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public Optional<Endereco> obtemLogradouroPorCep(String cep) {
        try {
            ResponseEntity<Endereco> response = restTemplate.exchange(
                API_URL,
                HttpMethod.GET,
                null,
                Endereco.class,
                cep);
            return Optional.ofNullable(response.getBody());
        } catch (HttpClientErrorException e) {
            System.out.println("Erro ao buscar CEP: " + e.getMessage());
            return Optional.empty();
        } catch (ResourceAccessException e) {
            System.out.println("Erro ao buscar CEP: " + e.getMessage());
            return Optional.empty();
        }
    }

    public Optional<EnderecoResponseDTO> obtemEnderecoPorCep(String cep) {
        try {
            ResponseEntity<Endereco> response = restTemplate.exchange(
                API_URL,
                HttpMethod.GET,
                null,
                Endereco.class,
                cep);
            
            Endereco endereco = response.getBody();
            if (endereco != null) {
                return Optional.of(EnderecoMapper.toResponseDTO(endereco));
            }
            return Optional.empty();
        } catch (HttpClientErrorException e) {
            System.out.println("Erro ao buscar CEP: " + e.getMessage());
            return Optional.empty();
        } catch (ResourceAccessException e) {
            System.out.println("Erro ao buscar CEP: " + e.getMessage());
            return Optional.empty();
        }
    }

}
