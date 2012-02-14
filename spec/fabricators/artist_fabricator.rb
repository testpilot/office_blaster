Fabricator(:artist) do
  name "Deadmau5"
end

Fabricator(:album) do
  name "The Art of Flight"
end

Fabricator(:song) do
  artist!
  title "Ghosts n stuff"
end
